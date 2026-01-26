const admin = require('firebase-admin');

// Initialize Firebase Admin SDK with emulator settings
admin.initializeApp({
  projectId: 'mkeparkapp-1ad15',
});

// Configure to use emulators BEFORE initializing Firestore
process.env.FIRESTORE_EMULATOR_HOST = '127.0.0.1:8080';
process.env.FIREBASE_FUNCTIONS_EMULATOR_HOST = '127.0.0.1:5001';

const db = admin.firestore();

async function testRealtimeNotifications() {
  console.log('🧪 Testing Real-Time Sighting Notifications');

  try {
    const sightingId = Date.now().toString();
    const uid = 'test_user_123';

    const sightingData = {
      type: 'parkingEnforcer',
      location: '123 Main St, Milwaukee',
      latitude: 43.0389,
      longitude: -87.9065,
      notes: 'Test sighting for notification system',
      reportedAt: new Date().toISOString(),
      occurrences: 1,
      createdAt: admin.firestore.FieldValue.serverTimestamp(),
      expiresAt: new Date(Date.now() + 2 * 60 * 60 * 1000), // 2 hours
      status: 'active'
    };

    console.log('📤 Creating test sighting in user collection...');

    // Create sighting in user collection (this should trigger mirrorUserSightingToGlobal)
    await db.collection('users').doc(uid).collection('sightings').doc(sightingId).set(sightingData);

    console.log('✅ Sighting created in user collection');

    // Wait for processing
    console.log('⏳ Waiting for Cloud Functions to process...');
    await new Promise(resolve => setTimeout(resolve, 3000));

    // Check if sighting was mirrored to global collection
    console.log('🔍 Checking global sightings collection...');
    const globalDoc = await db.collection('sightings').doc(sightingId).get();
    if (globalDoc.exists) {
      console.log('✅ Sighting mirrored to global collection');
      console.log('Global sighting data:', globalDoc.data());
    } else {
      console.log('❌ Sighting not found in global collection');
    }

    // Check if alert was created
    console.log('🔍 Checking alerts collection...');
    const alertDoc = await db.collection('alerts').doc(sightingId).get();
    if (alertDoc.exists) {
      console.log('✅ Alert created successfully');
      const alertData = alertDoc.data();
      console.log('Alert details:');
      console.log('- Title:', alertData.title);
      console.log('- Active:', alertData.active);
      console.log('- Type:', alertData.type);
      console.log('- Status:', alertData.status);
    } else {
      console.log('❌ Alert not found');
    }

    console.log('✅ Test completed - check function logs for notification triggers');

  } catch (error) {
    console.error('❌ Test failed:', error);
  } finally {
    // Clean up
    await admin.app().delete();
  }
}

testRealtimeNotifications();