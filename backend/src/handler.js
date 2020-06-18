exports.handler = async (event) => {
  // TODO implement
  var data = {
    health: 'ok',
    text: 'Bienvenue à toi'
  };
  const response = {
    statusCode: 200,
    body: data
  };
  return response;
};


