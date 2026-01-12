# Repository Guidelines

## Project Structure & Module Organization
- `contracts/` holds the Solidity core (ERC20, Factory, Pair), shared `interfaces/`, math helpers in `libraries/`, and `test/ERC20.sol` as a fixture token.
- `test/` contains TypeScript mocha specs plus `test/shared` fixtures and utilities; `.mocharc.json` wires ts-node and timeouts. `.waffle.json` pins solc 0.5.16 and optimizer settings.
- Build artifacts are generated into `build/` (gitignored). Root configs: `.prettierrc` (format), `tsconfig.json` (strict TS), `package.json` (scripts).

## Build, Test, and Development Commands
- `yarn` installs dependencies (Node >= 10).
- `yarn clean` removes `build/`; `yarn compile` (runs `precompile`) compiles Solidity via Waffle into `build/`.
- `yarn test` runs mocha specs through ts-node; compilation runs automatically via `pretest`.
- `yarn lint` checks formatting on `test/*.ts`; `yarn lint:fix` applies Prettier fixes.

## Coding Style & Naming Conventions
- Solidity: pragma 0.5.16; 4-space indentation; keep revert strings consistent (`UniswapV2: …`); follow existing public variable ordering and prefer internal helpers for invariant checks.
- TypeScript tests: keep files named `*.spec.ts` with `describe`/`it` blocks; adhere to Prettier rules (no semicolons, single quotes, 120-char width) and strict compiler options.
- File names match contract names (PascalCase); helper utilities remain lowerCamelCase.

## Testing Guidelines
- Add or extend specs under `test/`; reuse `test/shared/fixtures.ts` for factory/pair deployments and `utilities.ts` for EIP712, CREATE2, and price helpers.
- Cover happy paths and revert cases for any new behavior; mirror revert strings exactly.
- For focused runs, use `yarn test --grep "<keyword>"`. If iterating on bytecode, run `yarn compile` once to refresh artifacts.

## Commit & Pull Request Guidelines
- Commit messages should be concise and imperative (e.g., `fix: guard swap reserves`); prefer small, topical commits.
- Pull requests should outline intent, key changes, and linked issues/PRs; note any gas or behavioral shifts and list new/updated tests.
- Ensure `yarn lint` and `yarn test` pass before review; avoid committing generated `build/` artifacts.

## Security & Configuration Tips
- Never commit secrets or private keys; tests rely on the local waffle/ethers provider.
- When modifying protocol-critical math, call out invariants touched (reserves, k, fees) and add comments near non-obvious logic.
