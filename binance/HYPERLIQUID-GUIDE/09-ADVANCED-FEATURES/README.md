# Advanced Features & API Complete Guide

## API Overview

### API Architecture
```
REST API: Request-response model
WebSocket: Real-time streaming
Rate Limits: Generous for trading
Authentication: API key + secret

Base URL: https://api.hyperliquid.xyz
WS URL: wss://api.hyperliquid.xyz/ws
```

### Getting API Access
```
1. Log into account
2. Navigate to API settings
3. Generate API key
4. Save secret securely
5. Set permissions
6. IP whitelist (recommended)

Never share API keys
Rotate regularly
```

## REST API Endpoints

### Market Data Endpoints

#### Get Order Book
```python
GET /orderbook/{symbol}

Response:
{
  "bids": [[price, size], ...],
  "asks": [[price, size], ...],
  "timestamp": 1234567890
}

Use: Build order book locally
```

#### Get Tickers
```python
GET /tickers

Response:
{
  "BTC-PERP": {
    "last": 50000,
    "bid": 49999,
    "ask": 50001,
    "volume24h": 1000000
  }
}

Use: Monitor all markets
```

#### Get Candles
```python
GET /candles/{symbol}
Params: interval (1m, 5m, 1h, 1d)

Response:
[
  [timestamp, open, high, low, close, volume],
  ...
]

Use: Build charts, indicators
```

### Trading Endpoints

#### Place Order
```python
POST /order
Body: {
  "symbol": "BTC-PERP",
  "side": "buy",
  "type": "limit",
  "price": 49950,
  "size": 0.1,
  "reduceOnly": false,
  "postOnly": true
}

Response: {
  "orderId": "123456",
  "status": "new"
}
```

#### Cancel Order
```python
DELETE /order/{orderId}

Response: {
  "orderId": "123456",
  "status": "cancelled"
}
```

#### Get Positions
```python
GET /positions

Response: {
  "positions": [{
    "symbol": "BTC-PERP",
    "size": 0.5,
    "entryPrice": 50000,
    "markPrice": 50500,
    "pnl": 250,
    "margin": 2500
  }]
}
```

### Account Endpoints

#### Get Balance
```python
GET /account/balance

Response: {
  "equity": 10000,
  "balance": 9500,
  "margin": 2000,
  "availableMargin": 7500,
  "unrealizedPnl": 500
}
```

#### Get Trade History
```python
GET /trades
Params: symbol, startTime, endTime

Response: {
  "trades": [{
    "id": "789",
    "symbol": "BTC-PERP",
    "side": "buy",
    "price": 50000,
    "size": 0.1,
    "fee": -0.5,
    "timestamp": 1234567890
  }]
}
```

## WebSocket Streams

### Connecting to WebSocket
```javascript
const ws = new WebSocket('wss://api.hyperliquid.xyz/ws');

ws.on('open', () => {
  // Subscribe to streams
  ws.send(JSON.stringify({
    "method": "subscribe",
    "params": ["trades", "orderbook", "positions"]
  }));
});

ws.on('message', (data) => {
  const message = JSON.parse(data);
  // Handle updates
});
```

### Available Streams

#### Trade Stream
```json
{
  "type": "trade",
  "symbol": "BTC-PERP",
  "price": 50000,
  "size": 0.5,
  "side": "buy",
  "timestamp": 1234567890
}

Real-time trade feed
```

#### Order Book Stream
```json
{
  "type": "orderbook",
  "symbol": "BTC-PERP",
  "bids": [[49999, 10], ...],
  "asks": [[50001, 10], ...],
  "timestamp": 1234567890
}

Live order book updates
```

#### Position Updates
```json
{
  "type": "position",
  "symbol": "BTC-PERP",
  "size": 0.5,
  "entryPrice": 50000,
  "markPrice": 50100,
  "pnl": 50
}

Your position changes
```

## Trading Bots Development

### Basic Bot Structure
```python
import asyncio
import aiohttp
from datetime import datetime

class HyperliquidBot:
    def __init__(self, api_key, api_secret):
        self.api_key = api_key
        self.api_secret = api_secret
        self.base_url = "https://api.hyperliquid.xyz"

    async def get_orderbook(self, symbol):
        async with aiohttp.ClientSession() as session:
            async with session.get(f"{self.base_url}/orderbook/{symbol}") as resp:
                return await resp.json()

    async def place_order(self, symbol, side, price, size):
        headers = self.get_auth_headers()
        body = {
            "symbol": symbol,
            "side": side,
            "type": "limit",
            "price": price,
            "size": size
        }
        async with aiohttp.ClientSession() as session:
            async with session.post(f"{self.base_url}/order", json=body, headers=headers) as resp:
                return await resp.json()

    async def run_strategy(self):
        while True:
            # Implement your strategy
            await asyncio.sleep(1)
```

### Market Making Bot
```python
class MarketMaker(HyperliquidBot):
    def __init__(self, api_key, api_secret, spread=0.001):
        super().__init__(api_key, api_secret)
        self.spread = spread

    async def update_quotes(self, symbol):
        # Get mid price
        orderbook = await self.get_orderbook(symbol)
        mid_price = (orderbook['bids'][0][0] + orderbook['asks'][0][0]) / 2

        # Place orders
        buy_price = mid_price * (1 - self.spread)
        sell_price = mid_price * (1 + self.spread)

        await self.place_order(symbol, 'buy', buy_price, 0.1)
        await self.place_order(symbol, 'sell', sell_price, 0.1)
```

### Arbitrage Bot
```python
class ArbitrageBot(HyperliquidBot):
    def __init__(self, api_key, api_secret):
        super().__init__(api_key, api_secret)

    async def check_arbitrage(self):
        # Compare prices across markets
        hl_price = await self.get_price('BTC-PERP')
        external_price = await self.get_external_price('BTC')

        spread = (external_price - hl_price) / hl_price

        if spread > 0.002:  # 0.2% opportunity
            # Execute arbitrage
            await self.execute_arb(spread)
```

## Advanced Trading Strategies

### Grid Trading Implementation
```python
class GridBot(HyperliquidBot):
    def __init__(self, api_key, api_secret, levels=10, range_pct=0.1):
        super().__init__(api_key, api_secret)
        self.levels = levels
        self.range_pct = range_pct

    async def setup_grid(self, symbol, center_price, size_per_level):
        # Calculate grid levels
        upper = center_price * (1 + self.range_pct)
        lower = center_price * (1 - self.range_pct)

        buy_levels = []
        sell_levels = []

        for i in range(self.levels):
            buy_price = lower + (center_price - lower) * i / self.levels
            sell_price = center_price + (upper - center_price) * i / self.levels

            buy_levels.append(buy_price)
            sell_levels.append(sell_price)

        # Place orders
        for price in buy_levels:
            await self.place_order(symbol, 'buy', price, size_per_level)

        for price in sell_levels:
            await self.place_order(symbol, 'sell', price, size_per_level)
```

### TWAP Execution
```python
class TWAPBot(HyperliquidBot):
    async def execute_twap(self, symbol, side, total_size, duration_seconds, intervals):
        size_per_interval = total_size / intervals
        interval_seconds = duration_seconds / intervals

        for i in range(intervals):
            # Execute portion
            await self.place_market_order(symbol, side, size_per_interval)

            # Wait
            await asyncio.sleep(interval_seconds)
```

## Analytics & Monitoring

### Performance Tracking
```python
class PerformanceTracker:
    def __init__(self):
        self.trades = []
        self.daily_pnl = {}

    def add_trade(self, trade):
        self.trades.append(trade)
        date = trade['timestamp'].date()
        if date not in self.daily_pnl:
            self.daily_pnl[date] = 0
        self.daily_pnl[date] += trade['pnl']

    def calculate_sharpe(self):
        returns = list(self.daily_pnl.values())
        mean_return = np.mean(returns)
        std_return = np.std(returns)
        sharpe = mean_return / std_return * np.sqrt(365)
        return sharpe

    def calculate_max_drawdown(self):
        cumulative = np.cumsum(list(self.daily_pnl.values()))
        running_max = np.maximum.accumulate(cumulative)
        drawdown = (cumulative - running_max) / running_max
        return np.min(drawdown)
```

### Real-time Monitoring
```python
class Monitor:
    def __init__(self, bot):
        self.bot = bot
        self.alerts = []

    async def monitor_positions(self):
        while True:
            positions = await self.bot.get_positions()

            for pos in positions:
                # Check risk
                if pos['pnl'] < -1000:  # Loss limit
                    await self.send_alert(f"Large loss on {pos['symbol']}")

                # Check exposure
                if pos['margin'] > 5000:  # Position too large
                    await self.send_alert(f"Large exposure on {pos['symbol']}")

            await asyncio.sleep(10)
```

## Data Collection & Analysis

### Order Book Recording
```python
class OrderBookRecorder:
    def __init__(self):
        self.data = []

    async def record(self, symbol):
        while True:
            orderbook = await self.get_orderbook(symbol)

            self.data.append({
                'timestamp': datetime.now(),
                'best_bid': orderbook['bids'][0][0],
                'best_ask': orderbook['asks'][0][0],
                'bid_depth': sum([x[1] for x in orderbook['bids'][:10]]),
                'ask_depth': sum([x[1] for x in orderbook['asks'][:10]]),
            })

            # Save periodically
            if len(self.data) > 1000:
                self.save_to_db()
                self.data = []

            await asyncio.sleep(1)
```

### Trade Analysis
```python
def analyze_trades(trades):
    df = pd.DataFrame(trades)

    # Win rate
    win_rate = len(df[df['pnl'] > 0]) / len(df)

    # Average win/loss
    avg_win = df[df['pnl'] > 0]['pnl'].mean()
    avg_loss = abs(df[df['pnl'] < 0]['pnl'].mean())

    # Risk reward
    risk_reward = avg_win / avg_loss

    # Profit factor
    gross_profit = df[df['pnl'] > 0]['pnl'].sum()
    gross_loss = abs(df[df['pnl'] < 0]['pnl'].sum())
    profit_factor = gross_profit / gross_loss

    return {
        'win_rate': win_rate,
        'avg_win': avg_win,
        'avg_loss': avg_loss,
        'risk_reward': risk_reward,
        'profit_factor': profit_factor
    }
```

## Security Best Practices

### API Key Security
```python
import os
from cryptography.fernet import Fernet

class SecureConfig:
    def __init__(self):
        self.key = os.environ.get('ENCRYPTION_KEY')
        self.cipher = Fernet(self.key)

    def encrypt_api_key(self, api_key):
        return self.cipher.encrypt(api_key.encode())

    def decrypt_api_key(self, encrypted_key):
        return self.cipher.decrypt(encrypted_key).decode()

# Never hardcode keys
API_KEY = os.environ.get('HL_API_KEY')
API_SECRET = os.environ.get('HL_API_SECRET')
```

### Rate Limiting
```python
class RateLimiter:
    def __init__(self, max_per_second=10):
        self.max_per_second = max_per_second
        self.requests = []

    async def acquire(self):
        now = time.time()
        # Remove old requests
        self.requests = [r for r in self.requests if now - r < 1]

        if len(self.requests) >= self.max_per_second:
            sleep_time = 1 - (now - self.requests[0])
            await asyncio.sleep(sleep_time)
            return await self.acquire()

        self.requests.append(now)
```

## Testing & Deployment

### Backtesting Framework
```python
class Backtester:
    def __init__(self, strategy, data):
        self.strategy = strategy
        self.data = data
        self.results = []

    def run(self, initial_capital=10000):
        capital = initial_capital
        positions = {}

        for timestamp, market_data in self.data.iterrows():
            signals = self.strategy.generate_signals(market_data)

            for signal in signals:
                if signal['action'] == 'buy':
                    # Execute buy
                    positions[signal['symbol']] = {
                        'size': signal['size'],
                        'entry': market_data['price']
                    }
                elif signal['action'] == 'sell':
                    # Calculate PnL
                    if signal['symbol'] in positions:
                        pnl = (market_data['price'] - positions[signal['symbol']]['entry']) * positions[signal['symbol']]['size']
                        capital += pnl
                        del positions[signal['symbol']]

        return capital - initial_capital
```

### Production Deployment
```yaml
# docker-compose.yml
version: '3'
services:
  trading-bot:
    build: .
    environment:
      - API_KEY=${API_KEY}
      - API_SECRET=${API_SECRET}
    restart: always
    logging:
      driver: json-file
      options:
        max-size: "10m"
        max-file: "3"

  monitoring:
    image: grafana/grafana
    ports:
      - "3000:3000"

  database:
    image: postgres:14
    volumes:
      - ./data:/var/lib/postgresql/data
```

## Tools & Libraries

### Recommended Libraries
```python
# Trading
ccxt          # Crypto exchange library
pandas        # Data manipulation
numpy         # Numerical computation
talib         # Technical indicators

# Async
asyncio       # Async programming
aiohttp       # Async HTTP
websockets    # WebSocket client

# Monitoring
prometheus    # Metrics
grafana       # Visualization
sentry        # Error tracking
```

### Development Tools
```
IDE: VS Code with Python extensions
Version Control: Git
Testing: pytest
Linting: pylint, black
Documentation: Sphinx
```

## Best Practices

### Code Organization
```
project/
├── src/
│   ├── strategies/
│   ├── indicators/
│   ├── risk/
│   └── utils/
├── tests/
├── config/
├── logs/
└── data/
```

### Error Handling
```python
async def safe_trade(self):
    try:
        result = await self.place_order(...)
        return result
    except NetworkError:
        # Retry logic
        await asyncio.sleep(1)
        return await self.safe_trade()
    except InsufficientFunds:
        # Alert and stop
        await self.alert("Insufficient funds")
        return None
    except Exception as e:
        # Log and continue
        logger.error(f"Unexpected error: {e}")
        return None
```

### Logging
```python
import logging

logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(name)s - %(levelname)s - %(message)s',
    handlers=[
        logging.FileHandler('trading.log'),
        logging.StreamHandler()
    ]
)

logger = logging.getLogger(__name__)
```

## Summary

### API Usage Guidelines
```
1. Start with paper trading
2. Test thoroughly
3. Implement proper error handling
4. Monitor constantly
5. Use rate limiting
6. Secure API keys
7. Log everything
8. Have kill switches
9. Regular backups
10. Continuous improvement
```

### Success Factors
```
Technical: Good code, robust systems
Strategic: Edge in markets
Risk: Proper management
Operations: Reliable infrastructure
Evolution: Continuous adaptation
```