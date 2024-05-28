document.addEventListener('DOMContentLoaded', () => {

    const loginButton = document.getElementById('signup-button');



    loginButton.addEventListener('click', (event) => {

        event.preventDefault();



        const username = document.getElementById('new-username').value.trim();

        const password = document.getElementById('new-password').value.trim();



        if (!username || !password) {

            alert("Both fields are required!");

            return;

        }



        fetch('http://localhost:8081/backend2.php', {

            method: 'POST',

            headers: { 'Content-Type': 'application/json' },

            body: JSON.stringify({ username, password })

        })

        .then(response => response.json())

        .then(data => {

            if (data.success) {

                // Store authentication info in session storage

                sessionStorage.setItem('isAuthenticated', 'true');

                sessionStorage.setItem('currentUser', username);

                alert('Login successful!');

                window.location.href = 'index.html';

            } else {

                alert('Utilisateur introuvable');

            }

        })

        .catch(error => {

            console.error('Error:', error);

        });

    });

});