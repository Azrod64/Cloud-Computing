let users = [];
const createUser = (username, password) => {
    const newUser = { id: users.length + 1, user: username, password: password };
    users.push(newUser);
    // Mise à jour du fichier JSON
    fetch('./data.json')
        .then(response => {
            if (!response.ok) {
                throw new Error('Failed to load data');
            }
            return response.json();
        })
        .then(data => {
            data.users.push(newUser);
            return fetch('./data.json', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json'
                },
                body: JSON.stringify(data)
            });
        })
        .then(response => {
            if (!response.ok) {
                throw new Error('Failed to update data');
            }
            console.log('User added successfully');
        })
        .catch(error => console.error('Error updating data:', error));
};

document.querySelector('.signup-form').addEventListener('submit', (event) => {
    event.preventDefault();

    const newUsername = document.getElementById('new-username').value;
    const newPassword = document.getElementById('new-password').value;

    if (newUsername.trim() === "" || newPassword.trim() === "") {
        alert('Please enter username and password');
        return;
    }

    createUser(newUsername, newPassword);
    alert('User created successfully');
    document.getElementById('new-username').value = "";
    document.getElementById('new-password').value = "";
});

