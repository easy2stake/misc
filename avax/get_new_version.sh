VERSION=1.6.0

wget https://github.com/ava-labs/avalanchego/releases/download/v${VERSION}/avalanchego-linux-amd64-v${VERSION}.tar.gz
tar -xzvf avalanchego-linux-amd64-v${VERSION}.tar.gz
cd avalanchego-v${VERSION}
tar -czvf avalanchego-v${VERSION}.tar.gz *
mv avalanchego-v${VERSION}.tar.gz ../
cd ..
rm -r avalanchego-linux-amd64-v${VERSION}.tar.gz avalanchego-v${VERSION}
