document.addEventListener('DOMContentLoaded', () => {

    // Déterminer la page actuelle

    const isSigninPage = document.getElementById('signup-button') !== null;

    const isIndexPage = document.getElementById('tweet-button') !== null;



    if (isSigninPage) {

        // Code spécifique à la page de connexion (signin.html)

        handleSigninPage();

    } else if (isIndexPage) {

        // Code spécifique à la page d'accueil avec les tweets (index.html)

        handleIndexPage();

    }

});



function handleSigninPage() {

    const loginButton = document.getElementById('signup-button');



    loginButton.addEventListener('click', (event) => {

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

}



function handleIndexPage() {

    var isAuthenticated = sessionStorage.getItem('isAuthenticated') === 'true';

    var currentUser = sessionStorage.getItem('currentUser');



    const commentsContainer = document.getElementById('comments-container');

    const tweetButton = document.getElementById('tweet-button');



    let threads = [];



    const fetchThreads = async () => {

        try {

            const response = await fetch('http://localhost:80/index.php');

            const data = await response.json();



            if (data.error) {

                console.error(data.error);

                return;

            }



            // Sort posts by ID in descending order

            data.sort((a, b) => b.id - a.id);



            threads = data.map(item => ({

                author: item.name,

                date: new Date(item.date_created).toLocaleString(),

                content: item.content

            }));



            renderThreads(threads);

        } catch (error) {

            console.error('Error fetching threads:', error);

        }

    };



    const renderThreads = (threads) => {

        commentsContainer.innerHTML = "";

        threads.forEach(thread => {

            const commentHTML = `

            <div class="comment">

                <div class="comment-author">${thread.author}</div>

                <div class="comment-date">${thread.date}</div>

                <div class="comment-content">${thread.content}</div>

            </div>

            `;

            commentsContainer.insertAdjacentHTML('beforeend', commentHTML);

        });

    };



    fetchThreads();



    tweetButton.disabled = !isAuthenticated;



    const postTweet = async (author, content) => {

        try {

            const response = await fetch('http://localhost:80/index.php', {

                method: 'POST',

                headers: { 'Content-Type': 'application/json' },

                body: JSON.stringify({ author, content })

            });



            const data = await response.json();



            if (data.success) {

                const newThread = {

                    author,

                    date: new Date().toLocaleString(),

                    content

                };



                threads.unshift(newThread);

                renderThreads(threads);

            } else {

                console.error('Error posting tweet:', data.error);

            }

        } catch (error) {

            console.error('Error posting tweet:', error);

        }

    };



    tweetButton.addEventListener('click', () => {

        if (!isAuthenticated) {

            alert('You need to log in to tweet.');

            return;

        }



        const tweetContent = document.getElementById('tweet-content').value.trim();

        if (tweetContent === "") return;



        postTweet(currentUser, tweetContent);



        document.getElementById('tweet-content').value = "";

    });

}