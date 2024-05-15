var threads = [
    {
        author: "Jack",
        date: Date.now(),
        content: "Hey there"
    },
    {
        author: "Arthur",
        date: Date.now(),
        content: "Hey to you too"
    }
];

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

document.addEventListener('DOMContentLoaded', () => {
    const commentsContainer = document.getElementById('comments-container');
    const tweetButton = document.getElementById('tweet-button');

    tweetButton.disabled = !isAuthenticated; // Disable tweet button if not authenticated

    const renderThreads = (threads) => {
        commentsContainer.innerHTML = "";
        threads.forEach(thread => {
            const commentHTML = `
            <div class="comment">
                <div class="comment-author">${thread.author}</div>
                <div class="comment-date">${new Date(thread.date).toLocaleString()}</div>
                <div class="comment-content">${thread.content}</div>
            </div>
            `;
            commentsContainer.insertAdjacentHTML('beforeend', commentHTML);
        });
    };

    renderThreads(threads);

    const validateLogin = (username, password) => {
        return users.some(user => user.user === username && user.password === password);
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

        if (validateLogin(username, password)) {
            isAuthenticated = true;
            hidePopup();
            alert('Logged in successfully');
            tweetButton.disabled = false; // Enable tweet button on successful login
        } else {
            alert('Invalid login credentials');
        }
    });

    document.getElementById('tweet-button').addEventListener('click', () => {
        if (!isAuthenticated) return; // Prevent tweeting if not authenticated

        const tweetContent = document.getElementById('tweet-content').value.trim();
        if (tweetContent === "") return;

        const newThread = {
            author: "You",
            date: Date.now(),
            content: tweetContent
        };

        threads.unshift(newThread);
        renderThreads(threads);

        document.getElementById('tweet-content').value = "";
    });
});
