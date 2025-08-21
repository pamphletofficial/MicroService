#!/bin/bash

# 🚀 Full Script to Rename a Spring Boot Maven Project
# Usage: ./rename-springboot.sh NewProjectName
# Place this script in the ROOT directory of the project

if [ $# -ne 1 ]; then
    echo "❌ Usage: $0 <NewProjectName>"
    exit 1
fi

NEW_NAME=$1
OLD_NAME="MicroService"

echo "🔄 Renaming Spring Boot Project: $OLD_NAME → $NEW_NAME"

# 1. Update artifactId and name in pom.xml
if grep -q "<artifactId>$OLD_NAME</artifactId>" pom.xml; then
    sed -i "s|<artifactId>$OLD_NAME</artifactId>|<artifactId>$NEW_NAME</artifactId>|g" pom.xml
    echo "✅ Updated artifactId in pom.xml"
fi

if grep -q "<name>$OLD_NAME</name>" pom.xml; then
    sed -i "s|<name>$OLD_NAME</name>|<name>$NEW_NAME</name>|g" pom.xml
    echo "✅ Updated <name> in pom.xml"
fi

# 2. Rename main Application class
MAIN_APP_FILE=$(find src/main/java -type f -name "${OLD_NAME}Application.java" | head -n 1)
if [ -n "$MAIN_APP_FILE" ]; then
    NEW_MAIN_APP_FILE=$(dirname "$MAIN_APP_FILE")/"${NEW_NAME}Application.java"
    mv "$MAIN_APP_FILE" "$NEW_MAIN_APP_FILE"
    sed -i "s/class ${OLD_NAME}Application/class ${NEW_NAME}Application/g" "$NEW_MAIN_APP_FILE"
    echo "✅ Renamed main application class"
fi

# 3. Rename test Application class
TEST_APP_FILE=$(find src/test/java -type f -name "${OLD_NAME}ApplicationTests.java" | head -n 1)
if [ -n "$TEST_APP_FILE" ]; then
    NEW_TEST_APP_FILE=$(dirname "$TEST_APP_FILE")/"${NEW_NAME}ApplicationTests.java"
    mv "$TEST_APP_FILE" "$NEW_TEST_APP_FILE"
    sed -i "s/class ${OLD_NAME}ApplicationTests/class ${NEW_NAME}ApplicationTests/g" "$NEW_TEST_APP_FILE"
    echo "✅ Renamed test application class"
fi

# 4. Update references in main Java code
grep -rl "$OLD_NAME" src/main/java | while read -r file; do
    sed -i "s/$OLD_NAME/$NEW_NAME/g" "$file"
done

# 5. Update references in test Java code
grep -rl "$OLD_NAME" src/test/java | while read -r file; do
    sed -i "s/$OLD_NAME/$NEW_NAME/g" "$file"
done

# 6. Update references in resources
grep -rl "$OLD_NAME" src/main/resources | while read -r file; do
    sed -i "s/$OLD_NAME/$NEW_NAME/g" "$file"
done

# 7. Rename Java package folder for main code
PKG_PATH_MAIN="src/main/java/com/pamphlet"
if [ -d "$PKG_PATH_MAIN/$OLD_NAME" ]; then
    mv "$PKG_PATH_MAIN/$OLD_NAME" "$PKG_PATH_MAIN/$NEW_NAME"
    echo "✅ Renamed main package folder: $PKG_PATH_MAIN/$OLD_NAME → $PKG_PATH_MAIN/$NEW_NAME"
fi

# 8. Rename Java package folder for test code
PKG_PATH_TEST="src/test/java/com/pamphlet"
if [ -d "$PKG_PATH_TEST/$OLD_NAME" ]; then
    mv "$PKG_PATH_TEST/$OLD_NAME" "$PKG_PATH_TEST/$NEW_NAME"
    echo "✅ Renamed test package folder: $PKG_PATH_TEST/$OLD_NAME → $PKG_PATH_TEST/$NEW_NAME"
fi

echo "🎉 Project successfully renamed to $NEW_NAME"
