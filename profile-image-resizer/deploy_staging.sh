echo "----stashing"
git stash
echo "----pulling master"
git checkout master
git pull
echo '----cleaning app-image-resizer'
rm -r node_modules
npm install
echo '----cleaning app-image-resizer'
serverless deploy -s staging
git tag --force 'avatar-resizer-latest-staging'
git push --force origin 'avatar-resizer-latest-staging'
echo '----unstashing code'
git stash apply

