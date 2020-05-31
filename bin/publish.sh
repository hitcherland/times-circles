cd build/js/prod;
git init;
git checkout -b gh-pages
git add *
git commit -m "publish"
git remote add origin git@github.com:hitcherland/times-circles.git
git push origin gh-pages --force
rm -rf .git