exports.handler = async function (event, context, callback) {
    const queryString = event["queryStringParameters"];

    console.log('QueryString: ', JSON.stringify(queryString));
    var response = {
        statusCode: 200,
        headers: {
            'Content-Type': 'text/html; charset=utf-8',
        },
        body: '<p>Hello world!</p>',
    }
    callback(null, response)
}
