var users = [
    {
        id: 1,
        user: "admin",
        password: "admin"
    },
    {
        id: 2,
        user: "romu",
        password: "romu"
    }
];

var isAuthenticated = false; // Variable to track if the user is authenticated
var currentUser = null; // Variable to store the current authenticated user

document.addEventListener('DOMContentLoaded', () => {
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

    tweetButton.disabled = !isAuthenticated; // Disable tweet button if not authenticated

    const validateLogin = (username, password) => {
        return users.find(user => user.user === username && user.password === password);
    };

    const showPopup = () => {
        document.getElementById('popup').style.display = 'flex';
        document.getElementById('popup-background').style.display = 'block';
    };

    const hidePopup = () => {
        document.getElementById('popup').style.display = 'none';
        document.getElementById('popup-background').style.display = 'none';
    };

    document.getElementById('login-btn').addEventListener('click', showPopup);

    document.getElementById('login-button').addEventListener('click', () => {
        const username = document.getElementById('username').value;
        const password = document.getElementById('password').value;

        const user = validateLogin(username, password);
        if (user) {
            isAuthenticated = true;
            currentUser = user; // Store the current user
            hidePopup();
            alert('Logged in successfully');
            tweetButton.disabled = false; // Enable tweet button on successful login
        } else {
            alert('Invalid login credentials');
        }
    });

    const postTweet = async (author, content) => {
        try {
            const response = await fetch('http://localhost:80/index.php', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json'
                },
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

    document.getElementById('tweet-button').addEventListener('click', () => {
        if (!isAuthenticated) return; // Prevent tweeting if not authenticated

        const tweetContent = document.getElementById('tweet-content').value.trim();
        if (tweetContent === "") return;

        postTweet(currentUser.user, tweetContent); // Use current user's username

        document.getElementById('tweet-content').value = "";
    });
});