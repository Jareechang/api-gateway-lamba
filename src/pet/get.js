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
    const { petId } = event["pathParameters"];
    const results = pets.filter((pet) => {
        return pet.id === petId; 
    });

    var response = {
        statusCode: 200,
        headers: {
            'Content-Type': 'application/json;',
        },
        body: JSON.stringify(results)
    }
    callback(null, response);
}
