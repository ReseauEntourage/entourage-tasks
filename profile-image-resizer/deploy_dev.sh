echo "----stashing"
git stash
echo "----pulling master"
git checkout master
git pull
echo '----cleaning app-image-resizer'
rm -r node_modules
npm install
echo '----cleaning app-image-resizer'
serverless deploy -s dev
git tag --force 'avatar-resizer-latest-dev'
git push --force origin 'avatar-resizer-latest-dev'
echo '----unstashing code'
git stash apply

