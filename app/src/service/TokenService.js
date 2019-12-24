

export default  async function mytokens(owner) {
     
    try {
      let response = await fetch('http://localhost:8080/listDeployedTokens?owner=' + owner, {
       
        cache: 'no-cache', // *default, no-cache, reload, force-cache, only-if-cached
        credentials: 'include', // include, same-origin, *omit
        headers: {
          'user-agent': 'Mozilla/4.0 MDN Example',
          'content-type': 'application/json'
        },
        method: 'GET', // *GET, POST, PUT, DELETE, etc.
        mode: 'cors', // no-cors, cors, *same-origin
        redirect: 'follow', // manual, *follow, error
        referrer: 'no-referrer', // *client, no-referrer
      })
      let json = await response.json() // parses response to JSON
      return json;
     
      
    } catch (err) {
      alert(err);
    } finally {

    }
  
  }