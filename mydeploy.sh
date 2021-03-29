#!/usr/bin/env bash
# Executing the following via 'ssh portfolio@157.90.230.148 -p 22 -tt':
#
#!/usr/bin/env bash

# Go to the deploy path
cd "/home/portfolio/app" || (
echo "! ERROR: not set up."
echo "The path '/home/portfolio/app' is not accessible on the server."
echo "You may need to run 'mina setup' first."
false
) || exit 15

# Check releases path
if [ ! -d "/home/portfolio/app/releases" ]; then
echo "! ERROR: not set up."
echo "The directory '/home/portfolio/app/releases' does not exist on the server."
echo "You may need to run 'mina setup' first."
exit 16
fi

# Check lockfile
if [ -e "deploy.lock" ]; then
echo "! ERROR: another deployment is ongoing."
echo "The file 'deploy.lock' was found. File was last modified at $(stat -c %y deploy.lock)"
echo "If no other deployment is ongoing, run 'mina deploy:force_unlock' to delete the file."
exit 17
fi

# Determine $previous_path and other variables
[ -h "/home/portfolio/app/current" ] && [ -d "/home/portfolio/app/current" ] && previous_path=$(cd "/home/portfolio/app/current" >/dev/null && pwd -LP)
build_path="./tmp/build-$(date +%s)$RANDOM"

version="$((`ls -1 /home/portfolio/app/releases | sort -n | tail -n 1`+1))"
release_path="/home/portfolio/app/releases/$version"

# Sanity check
if [ -e "$build_path" ]; then
echo "! ERROR: Path already exists."
exit 18
fi

# Bootstrap script (in deployer)
(
echo "-----> Creating a temporary build path"
touch "deploy.lock" &&
mkdir -p "$build_path" &&
cd "$build_path" &&
(
  if [ ! -d "/home/portfolio/app/scm/objects" ]; then
    echo "-----> Cloning the Git repository"
    git clone "git@github.com:0000magda0000/portfolio.git" "/home/portfolio/app/scm" --bare
  else
    echo "-----> Fetching new git commits"
    (cd "/home/portfolio/app/scm" && git fetch "git@github.com:0000magda0000/portfolio.git" "master:master" --force)
  fi &&
  echo "-----> Using git branch 'master'" &&
  git clone "/home/portfolio/app/scm" . --recursive --branch "master" &&
  echo "-----> Using this git commit" &&
  git rev-parse HEAD > .mina_git_revision &&
  git --no-pager log --format="%aN (%h):%n> %s" -n 1 &&
  rm -rf .git &&
  echo "-----> Symlinking shared paths" &&
  if [ ! -d  "/home/portfolio/app/shared/vendor/bundle" ]; then
    echo "! ERROR: not set up."
    echo "The directory '/home/portfolio/app/shared/vendor/bundle' does not exist on the server"
    echo "You may need to run 'mina setup' first"
    exit 18
  fi &&
  mkdir -p ./vendor &&
  rm -rf "./vendor/bundle" &&
  ln -s "/home/portfolio/app/shared/vendor/bundle" "./vendor/bundle" &&
  if [ ! -d  "/home/portfolio/app/shared/log" ]; then
    echo "! ERROR: not set up."
    echo "The directory '/home/portfolio/app/shared/log' does not exist on the server"
    echo "You may need to run 'mina setup' first"
    exit 18
  fi &&
  mkdir -p . &&
  rm -rf "./log" &&
  ln -s "/home/portfolio/app/shared/log" "./log" &&
  if [ ! -d  "/home/portfolio/app/shared/tmp/cache" ]; then
    echo "! ERROR: not set up."
    echo "The directory '/home/portfolio/app/shared/tmp/cache' does not exist on the server"
    echo "You may need to run 'mina setup' first"
    exit 18
  fi &&
  mkdir -p ./tmp &&
  rm -rf "./tmp/cache" &&
  ln -s "/home/portfolio/app/shared/tmp/cache" "./tmp/cache" &&
  if [ ! -d  "/home/portfolio/app/shared/public/assets" ]; then
    echo "! ERROR: not set up."
    echo "The directory '/home/portfolio/app/shared/public/assets' does not exist on the server"
    echo "You may need to run 'mina setup' first"
    exit 18
  fi &&
  mkdir -p ./public &&
  rm -rf "./public/assets" &&
  ln -s "/home/portfolio/app/shared/public/assets" "./public/assets" &&
  ln -sf "/home/portfolio/app/shared/config/database.yml" "./config/database.yml" &&
  ln -sf "/home/portfolio/app/shared/config/secrets.yml" "./config/secrets.yml" &&
  echo "-----> Installing gem dependencies using Bundler" &&
  bundle install --without development test --path "vendor/bundle" --deployment &&
  if diff -qrN "/home/portfolio/app/current/db/migrate" "./db/migrate" 2>/dev/null
  then
    echo "-----> DB migrations unchanged; skipping DB migration"
  else
    echo "-----> Migrating database"
        RAILS_ENV="production" bundle exec rake db:migrate
  fi &&
  if diff -qrN "/home/portfolio/app/current/vendor/assets/" "./vendor/assets/" 2>/dev/null && diff -qrN "/home/portfolio/app/current/app/assets/" "./app/assets/" 2>/dev/null
  then
    echo "-----> Skipping asset precompilation"
  else
    echo "-----> Precompiling asset files"
        RAILS_ENV="production" bundle exec rake assets:precompile
  fi &&
  echo "-----> Cleaning up old releases (keeping 5)" &&
  (cd /home/portfolio/app/releases && count=$(ls -A1 | sort -rn | wc -l) && remove=$((count > 5 ? count - 5 : 0)) && ls -A1 | sort -rn | tail -n $remove | xargs rm -rf {} && cd -)
) &&
echo "-----> Deploy finished"
) &&

#
# Build
(
echo "-----> Building"
echo "-----> Moving build to $release_path"
mv "$build_path" "$release_path" &&
cd "$release_path" &&
(
true
) &&
echo "-----> Build finished"

) &&

#
# Launching
# Rename to the real release path, then symlink 'current'
(
echo "-----> Launching"
echo "-----> Updating the /home/portfolio/app/current symlink" &&
ln -nfs "$release_path" "/home/portfolio/app/current"
) &&

# ============================
# === Start up server => (in deployer)
(
cd "/home/portfolio/app/current"
true
) &&

# ============================
# === Complete & unlock
(
rm -f "deploy.lock"
echo "-----> Done. Deployed version $version"
) ||

# ============================
# === Failed deployment
(
echo "! ERROR: Deploy failed."



echo "-----> Cleaning up build"
[ -e "$build_path" ] && (
  rm -rf "$build_path"
)
[ -e "$release_path" ] && (
  echo "Deleting release"
  rm -rf "$release_path"
)
(
  echo "Unlinking current"
  [ -n "$previous_path" ] && ln -nfs "$previous_path" "/home/portfolio/app/current"
)

# Unlock
rm -f "deploy.lock"
echo "OK"
exit 19
)
 
       [96mElapsed time: 0.00 seconds[0m
