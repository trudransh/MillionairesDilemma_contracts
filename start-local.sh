#!/bin/bash

# Start Anvil in the background with a known private key
echo "Starting Anvil..."
anvil --chain-id 31337 --block-time 2 --hardfork latest --private-key 0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80 > /dev/null 2>&1 &
ANVIL_PID=$!

# Wait for Anvil to start
sleep 2
echo "Anvil started with PID: $ANVIL_PID"

# Set environment variables
export PRIVATE_KEY=0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80
export RPC_URL=http://127.0.0.1:8545

# Move to contracts directory
cd contracts

# Run the deployment script - exclude test files
echo "Deploying contracts..."
forge script script/Deploy.sol:DeployScript --rpc-url $RPC_URL --broadcast 


# Update the contract addresses in the frontend
cd ../frontend
cat > .env.local << EOF
NEXT_PUBLIC_MILLIONAIRES_DILEMMA_FACTORY_ADDRESS=$FACTORY_ADDRESS
NEXT_PUBLIC_CHAIN_ID=31337
EOF

echo "Setup complete. Local environment is  ready."
echo "To terminate Anvil, run: kill $ANVIL_PID" 