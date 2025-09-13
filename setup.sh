#!/bin/bash
# Mine-Ubuntu Setup Script (With RAM Prompt)

echo "========================================"
echo "        Mine-Ubuntu Setup Wizard         "
echo "========================================"
echo ""

# Ask for version
read -p "Enter Minecraft version (e.g. 1.21.7): " VERSION
# Ask for build
read -p "Enter PaperMC build number (e.g. 17): " BUILD

# Ask for RAM allocation
read -p "Enter minimum RAM (e.g. 1G, 512M): " RAM_MIN
read -p "Enter maximum RAM (e.g. 2G, 4G): " RAM_MAX

# Create server folder
SERVER_DIR="$HOME/mine-ubuntu-server"
mkdir -p "$SERVER_DIR"
cd "$SERVER_DIR" || exit

# Download PaperMC jar
JAR_NAME="paper-$VERSION-$BUILD.jar"
URL="https://api.papermc.io/v2/projects/paper/versions/$VERSION/builds/$BUILD/downloads/$JAR_NAME"

echo "Downloading PaperMC $VERSION build $BUILD ..."
wget -O server.jar "$URL"

if [ $? -ne 0 ]; then
  echo "❌ Download failed. Check version or build number."
  exit 1
fi

# Auto accept EULA
echo "eula=true" > eula.txt

# Create start.sh with user RAM choice
cat > start.sh <<EOF
#!/bin/bash
cd "\$(dirname "\$0")"
java -Xms$RAM_MIN -Xmx$RAM_MAX -jar server.jar nogui
EOF

chmod +x start.sh

echo ""
echo "✅ Setup completed!"
echo "Server files are in: $SERVER_DIR"
echo "Run your server with: $SERVER_DIR/start.sh"
