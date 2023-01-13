echo "----stashing"
git stash
echo "----pulling master"
git checkout master
git pull
echo '----cleaning user_engagement'
rm -r node_modules
npm install
echo '----cleaning user_engagement'
serverless deploy -s dev
echo '----unstashing code'
git stash apply

