cd app-image-resizer
echo '----cleaning app-image-resizer'
rm -r node_modules
npm install
echo '----deploying app-image-resizer'
serverless deploy -s staging

cd ../user-engagement
echo '----cleaning user-engagement'
rm -r node_modules
npm install
echo '----deploying user-engagement'
serverless deploy -s dev

