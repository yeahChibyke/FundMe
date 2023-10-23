I will be writing the processes and steps I took when refactoring this code
This way I can look back and copy this steps in future projects
- pass an 'address priceFeed' as a constructor parameter
- declare a new variable: 'AggregatorV3Interface s_priceFeed'
- in our constructor, initialize 's_priceFeed'
```
  AggregatorV3Interface private s_priceFeed;

  constructor(address priceFeed) {
  i_owner = msg.sender;
  s_priceFeed = AggregatorV3Interface(priceFeed);
  }
```