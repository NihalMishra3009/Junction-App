const qrcode = require('qrcode');
const path = require('path');
const fs = require('fs');

// GitHub Release APK URL
const releaseUrl = 'https://github.com/NihalMishra3009/Junction-App/releases/latest/download/junction-attendee.apk';

console.clear();
console.log('\x1b[33m%s\x1b[0m', '==========================================================');
console.log('\x1b[1m\x1b[37m%s\x1b[0m', '   📱 JUNCTION ATTENDEE APK - GITHUB RELEASE SCANNER');
console.log('\x1b[33m%s\x1b[0m', '==========================================================');
console.log(`Direct Release APK Link : \x1b[36m${releaseUrl}\x1b[0m\n`);

// 1. Render ASCII QR Code in terminal
qrcode.toString(releaseUrl, { type: 'terminal', small: true }, (err, qrText) => {
  if (err) {
    console.error('Error generating terminal QR:', err);
    return;
  }
  console.log(qrText);
  console.log('\x1b[32m%s\x1b[0m', '>> POINT ANY PHONE CAMERA AT THIS QR CODE TO DOWNLOAD & INSTALL APP\n');
});

// 2. Save High-Res PNG image for README and web download
const outputPng = path.join(__dirname, 'public', 'junction-qr.png');
qrcode.toFile(outputPng, releaseUrl, {
  width: 500,
  margin: 2,
  color: {
    dark: '#000000',
    light: '#ffffff',
  },
}, (err) => {
  if (!err) {
    console.log(`\x1b[90m✓ High-Res QR code saved to: public/junction-qr.png\x1b[0m\n`);
  }
});
