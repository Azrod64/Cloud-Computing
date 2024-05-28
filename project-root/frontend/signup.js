document.addEventListener('DOMContentLoaded', () => {

    const signupButton = document.getElementById('signup-button');

    if (signupButton) {

        signupButton.addEventListener('click', (event) => {

            event.preventDefault();



            const username = document.getElementById('new-username').value.trim();

            const password = document.getElementById('new-password').value.trim();



            if (!username || !password) {

                alert("Both fields are required!");

                return;

            }



            fetch('http://localhost:8081/index.php', {

                method: 'POST',

                headers: { 'Content-Type': 'application/json' },

                body: JSON.stringify({ action: 'signup', username, password })

            })

            .then(response => response.json())

            .then(data => {

                if (data.success) {

                    alert('Account created successfully!');

                    window.location.href = 'signin.html'; // Redirect to sign in page after successful signup

                } else {

                    alert('Error creating account. Please try again.');

                }

            })

            .catch(error => {

                console.error('Error:', error);

            });

        });

    }

});