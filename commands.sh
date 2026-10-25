# داخل مشروع core-utils المحلي
mkdir -p .github/workflows

cat > .github/workflows/publish.yml << 'YAML'
name: Publish package to GitHub Packages

on:
  release:
    types: [published]

permissions:
  contents: read
  packages: write

jobs:
  build-test-publish:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout
        uses: actions/checkout@v4

      - name: Setup Node.js
        uses: actions/setup-node@v4
        with:
          node-version: 20
          registry-url: https://npm.pkg.github.com
          scope: '@asalomeri'

      - name: Install dependencies
        run: npm ci

      - name: Lint
        run: npm run lint --if-present

      - name: Test
        run: npm test --if-present

      - name: Build
        run: npm run build --if-present

      - name: Publish
        run: npm publish
        env:
          NODE_AUTH_TOKEN: ${{ secrets.GITHUB_TOKEN }}
YAML

cat > package.json << 'JSON'
{
  "name": "@asalomeri/core-utils",
  "version": "1.0.0",
  "description": "Reusable core utilities for JavaScript/TypeScript projects.",
  "license": "MIT",
  "type": "module",
  "main": "./dist/index.js",
  "types": "./dist/index.d.ts",
  "exports": {
    ".": {
      "types": "./dist/index.d.ts",
      "default": "./dist/index.js"
    }
  },
  "files": ["dist", "README.md", "LICENSE"],
  "repository": {
    "type": "git",
    "url": "https://github.com/asalomeri/core-utils.git"
  },
  "homepage": "https://github.com/asalomeri/core-utils#readme",
  "bugs": {
    "url": "https://github.com/asalomeri/core-utils/issues"
  },
  "publishConfig": {
    "registry": "https://npm.pkg.github.com"
  },
  "scripts": {
    "build": "tsc -p tsconfig.json",
    "lint": "echo \"No lint configured yet\"",
    "test": "echo \"No tests configured yet\"",
    "prepublishOnly": "npm run build"
  },
  "engines": {
    "node": ">=20"
  }
}
JSON

git add .github/workflows/publish.yml package.json
git commit -m "setup: publish @asalomeri/core-utils to GitHub Packages"
git push
