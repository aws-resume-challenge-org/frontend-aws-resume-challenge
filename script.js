
// Define the function to fetch data from the API
function fetchData() {
    fetch('https://7vgsgyibz8.execute-api.us-west-2.amazonaws.com/getVisitorCount')
        .then(response => {
            // Check if the response is successful
            if (!response.ok) {
                throw new Error('Failed to fetch data');
            }
            // Parse the JSON response
            return response.json();
        })
        .then(data => {
            // Display the data on the webpage
            const container = document.getElementById('data-container');
            container.innerHTML = '';

            // Create HTML elements to display response data
            const visitorsText = document.createElement('p');
            visitorsText.textContent = 'Visitor Count: ' + JSON.stringify(data);

            // Append elements to the container
            container.appendChild(visitorsText);
        })
        .catch(error => {
            // Handle any errors
            console.error('Error:', error);
            const container = document.getElementById('data-container');
            container.textContent = 'Error: ' + error.message;
        });
}