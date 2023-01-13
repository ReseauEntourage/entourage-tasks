./linux_install.sh

cd app-image-resizer
echo '----deploying app-image-resizer'
npm run deploy

cd ../profile-image-resizer
echo '----deploying profile-image-resizer'
npm run deploy

cd ../user-engagement
echo '----deploying user-engagement'
npm run deploy

cd ..

