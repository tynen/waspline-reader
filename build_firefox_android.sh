# Create build directory
mkdir -p build

# Copy extension files
cp -r extension/* build/

# Create contentScript.js by combining lineWrapDetector.js and main.js
if [ -f "libs/lineWrapDetector.js" ] && [ -f "main.js" ]; then
  echo "Creating contentScript.js..."
  cat libs/lineWrapDetector.js main.js > build/contentScript.js
  echo "ContentScript.js created successfully"
  
  # Add debug logs
  sed -i '1s/^/console.log("WaspLine Reader: contentScript loaded");\n/' build/contentScript.js
fi