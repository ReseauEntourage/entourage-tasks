cd app-image-resizer
echo '----cleaning app-image-resizer'
rm -r node_modules
npm install
echo '----deploying app-image-resizer'
#serverless deploy -s staging

cd ../profile-image-resizer
echo '----cleaning profile-image-resizer'
rm -r node_modules
npm install
echo '----deploying profile-image-resizer'
#serverless deploy -s dev

cd ../user-engagement
echo '----cleaning user-engagement'
rm -r node_modules
npm install
echo '----deploying user-engagement'
#serverless deploy -s dev

cd ..

