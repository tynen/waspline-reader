#init NPM
npm init -y
npm install --save-dev web-ext
# Create build directory
mkdir -p build

# Copy extension files
cp -r extension/* build/

# Create contentScript.js by combining lineWrapDetector.js and main.js
if [ -f "libs/lineWrapDetector.js" ] && [ -f "main.js" ]; then
  echo "Creating contentScript.js..."
  cat libs/lineWrapDetector.js main.js > build/contentScript.js
  echo "ContentScript.js created successfully"
  
  # Check if we're building for production
  if [ "$1" != "production" ]; then
    echo "Adding debug logs (use './build_firefox_android.sh production' to skip)"
    sed -i '1s/^/console.log("WaspLine Reader: contentScript loaded");\n/' build/contentScript.js
  fi
fi

# List build contents to verify
echo "Build directory contents:"
ls -la build/

# Use local web-ext if available, otherwise suggest installation
if [ -f "node_modules/.bin/web-ext" ]; then
  ./node_modules/.bin/web-ext build --source-dir=build --artifacts-dir=builds --overwrite-dest
else
  echo "web-ext not found locally. Installing..."
  npm install --save-dev web-ext
  ./node_modules/.bin/web-ext build --source-dir=build --artifacts-dir=builds --overwrite-dest
fi

# Uncomment to test on Android
# ./node_modules/.bin/web-ext run --target=firefox-android --firefox-apk=org.mozilla.firefox --source-dir=./build --android-device=28021FDH300ASE