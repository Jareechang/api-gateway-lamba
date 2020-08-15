exports.handler = async function (event, context, callback) {
    const pets = [
        { 
            "id": 1, 
            "type": "dog", 
            "price": 249.99 
        }, 
        { 
            "id": 2, 
            "type": "cat", 
            "price": 124.99 
        }, 
        { 
            "id": 3, 
            "type": "fish", 
            "price": 0.99 
        } 
    ];
    const queryString = event["queryStringParameters"];

    console.log('QueryString: ', JSON.stringify(queryString));

    var response = {
        statusCode: 200,
        headers: {
            'Content-Type': 'application/json;',
        },
        body: JSON.stringify(pets),
    }
    callback(null, response)
}
