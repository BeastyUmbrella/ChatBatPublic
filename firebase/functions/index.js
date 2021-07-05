const functions = require("firebase-functions");
const admin = require('firebase-admin');
const geofirestore = require('geofirestore');
// var firebase = require('firebase/app');
// const { GeoFire } = require("geofire");
// const { firestore } = require("firebase-admin");
require('firebase/firestore');
admin.initializeApp();
const db = admin.firestore();
const fcm = admin.messaging();
// // Create and Deploy Your First Cloud Functions
// // https://firebase.google.com/docs/functions/write-firebase-functions
//
// exports.helloWorld = functions.https.onRequest((request, response) => {
//   functions.logger.info("Hello logs!", {structuredData: true});
//   response.send("Hello from Firebase!");
// });
const GeoFirestore = geofirestore.initializeApp(admin.firestore());
const geocollection = GeoFirestore.collection('searching');

// var query = geocollection.near({
//     center: new admin.firestore.GeoPoint(55.65321, 12.6162409),
//     radius: 5,
// });
// console.log(query);
// query.get().then((value) => {
//     // All GeoDocument returned by GeoQuery, like the GeoDocument added above
//     console.log(value.docs);
// });

exports.matchSearchingBats = functions.region('europe-west1').firestore.document('/searching/{id}').onWrite( async (snap, context) => {   
    await db.collection('/searching')
    .orderBy('searchTime')
    .get()
    .then(async querySnapshot => {
        if (querySnapshot.size > 1) {
            for (let i = 0; i <  querySnapshot.size; i++) {
                for (let j = 0; j < querySnapshot.size; j++) {
                    if (i != j){

                        var neari = await geocollection.near({
                            center: querySnapshot.docs[i].data()['g']["geopoint"],
                            radius: querySnapshot.docs[i].data()["radius"],
                        }).get();

                        var nearj = await geocollection.near({
                            center: querySnapshot.docs[j].data()['g']["geopoint"],
                            radius: querySnapshot.docs[j].data()["radius"],
                        }).get();
                        
                        let jExistsIni = false;
                        let iExistsInj = false;

                        for (let m = 0; m < neari.docs.length; m++) {
                            if (neari.docs[m].id != querySnapshot.docs[i].id && neari.docs[m].id == querySnapshot.docs[j].id){
                                jExistsIni = true;
                            }
                        }
                        for (let n = 0; n < nearj.docs.length; n++){
                            if (nearj.docs[n].id != querySnapshot.docs[j].id && nearj.docs[n].id == querySnapshot.docs[i].id){
                                iExistsInj = true;
                            }
                        }
                        
                        if (jExistsIni && iExistsInj){
                            if (!(await db.collection("/users/" + querySnapshot.docs[i].id + "/blocked").doc(querySnapshot.docs[j].id).get()).exists && !(await (db.collection("/users/" + querySnapshot.docs[j].id + "/blocked").doc(querySnapshot.docs[i].id).get())).exists){
                                if (querySnapshot.size > 1){
                                    if (!(await db.collection("/users/" + querySnapshot.docs[i].id + "/chattingWith").doc(querySnapshot.docs[j].id).get()).exists){
                                        await db.collection("/users/" + querySnapshot.docs[i].id + "/chattingWith").doc(querySnapshot.docs[j].id).set({'uid': querySnapshot.docs[j].id,'matchTime': Date.now(), "isSeen": false});
                                        await querySnapshot.docs[i].ref.delete();
                                    }
                                    if (!(await (db.collection("/users/" + querySnapshot.docs[j].id + "/chattingWith").doc(querySnapshot.docs[i].id).get())).exists){
                                        await db.collection("/users/" + querySnapshot.docs[j].id + "/chattingWith").doc(querySnapshot.docs[i].id).set({'uid': querySnapshot.docs[i].id,'matchTime': Date.now(), "isSeen": false});
                                        await querySnapshot.docs[1].ref.delete();
                                    }
                                }
                            }
                        }
                    }
                }
            } 
        }
    });
});

exports.newMatchNotification = functions.region('europe-west1').firestore.document('users/{id}/chattingWith/{chatid}').onCreate( async (snapshot, context) => {
    const newMatch = snapshot.data()['uid'];

    const user = (await db.collection("users").doc(newMatch).get());

    const querySnapshot = await db
        .collection('users')
        .doc(context.params.id)
        .collection('tokens')
        .get();
    
    const tokens = querySnapshot.docs.map(snap => snap.id);

    const payload = admin.messaging.MessagingPayload = {
        notification: {
            title: 'New Bat found!',
            body: 'Start chatting with ' + user.data()['displayName'],
            clickAction: 'FLUTTER_NOTIFICATION_CLICK'
        }
    };

    return fcm.sendToDevice(tokens, payload);
});

exports.newMessageNotification = functions.region('europe-west1').firestore.document('chats/{id}/{chattingWith}/{message}').onCreate( async (snapshot, context) => {
    if (context.params.chattingWith == snapshot.data()['uid']){
        const id = context.params.id;
        const chattingWith = context.params.chattingWith;
        const message = context.params.message;
        

        const user = (await db.collection("users").doc(snapshot.data()['uid']).get());

        const receiver = context.params.id;
        const querySnapshot = await db
            .collection('users')
            .doc(receiver)
            .collection('tokens')
            .get();

        const tokens = querySnapshot.docs.map(snap => snap.id);

        const payload = admin.messaging.MessagingPayload = {
            notification: {
                title: user.data()['displayName'],
                body: snapshot.data()['message'],
                clickAction: 'FLUTTER_NOTIFICATION_CLICK'
            }
        }

        return fcm.sendToDevice(tokens, payload);
    }
});