# Repository Guidelines

## Project Structure & Module Organization
Core Solidity sources live in `contracts/`, with production routers, libraries, and interfaces compiled to `build/`; legacy artifacts are stored in `buildV1/` for migration scripts. TypeScript integration and regression tests sit in `test/`, with fixtures and utilities under `test/shared/` to keep E2E setups reusable. Configuration roots include `package.json` for scripts and tool versions, `.waffle.json` for the compiler pipeline, and `tsconfig.json` for test transpilation.

## Build, Test, and Development Commands
- `yarn` installs Node.js >=10 dependencies and solidity tooling (`package.json:5-34`).
- `yarn clean && yarn compile` removes stale build output and re-runs `waffle .waffle.json`, copying v1 artifacts afterward (`package.json:35-43`).
- `yarn test` runs the Mocha suite through Waffle’s provider hooks; it automatically triggers `pretest` compilation (`package.json:43-45`).
- `yarn lint` (or `lint:fix`) executes Prettier on all spec files for deterministic formatting (`package.json:35-38`).

## Coding Style & Naming Conventions
Solidity code targets `pragma solidity =0.6.6` with four-space indentation, explicit visibility, and revert strings (see `contracts/UniswapV2Router02.sol:1-58`). Use `SafeMath` for arithmetic, immutable addresses for core dependencies, and descriptive `require` messages. TypeScript specs follow a two-space style with named `describe/it` blocks mirroring contract functions and uppercase constants for shared values (`test/UniswapV2Router02.spec.ts:1-120`). Prefer CamelCase filenames for contracts, PascalCase for classes, and lowerCamelCase for function parameters and local variables.

## Testing Guidelines
Tests rely on `mocha`, `chai`, and `ethereum-waffle` to deploy fixtures and assert revert reasons. Keep each spec focused on one contract or scenario (e.g., router quoting, flash swaps) and load fixtures via `createFixtureLoader` to isolate state (`test/UniswapV2Router02.spec.ts:21-38`). Name files `Something.spec.ts`, assert revert messages, and run `yarn test` before opening a PR, adding fixtures or helpers beside the specs they support.

## Commit & Pull Request Guidelines
The Git history favors short imperative subjects with optional scopes (e.g., `feat: add stale config`) and references to issues or PR numbers when relevant (`git log -5`). Ensure commits build cleanly. For pull requests, capture purpose, contract or interface impact, reproduction steps, and helpful calldata or screenshots, and call out gas or security implications of behavioral changes.

## Security & Configuration Tips
Never hardcode private keys; rely on Waffle’s deterministic mnemonic for tests (`test/UniswapV2Router02.spec.ts:21-27`). When touching router logic, double-check deadline handling and transfer helpers to avoid re-entrancy avenues, and keep ETH refunds explicit (see `TransferHelper.safeTransferETH` usage in router contracts).
