import React, { Component } from 'react';
import logo from './logo.svg';
import './App.css';

class App extends Component {

  constructor(props) {
    super(props);
    this.state = {
      statusCode: 200,
      body: {}
    };
  }

  componentDidMount() {
    fetch("https://gx927gllm6.execute-api.eu-west-1.amazonaws.com/default/my-first-lambda")
      .then(res => res.json())
      .then(
        (result) => {
          this.setState({
            statusCode: 200,
            body: result.body
          });
        }
      )
  }

  render() {
    const { statusCode, body } = this.state;
    return (
      <div className="App">
        <div className="App-header">
          <img src={logo} className="App-logo" alt="logo" />
          <h2>Template serverless web app</h2>
        </div>
        <div>
          {body.text}
        </div>
      </div>
    );
  }

}

export default App;
