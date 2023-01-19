echo "----stashing"
git stash
echo "----pulling master"
git checkout master
git pull
echo '----cleaning app-image-resizer'
rm -r node_modules
npm install
echo '----cleaning app-image-resizer'
serverless deploy -s prod
git tag --force 'image-resizer-latest-prod'
echo '----unstashing code'
git stash apply

