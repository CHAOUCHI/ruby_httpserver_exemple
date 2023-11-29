require "socket"
# create the server
server = TCPServer.new("localhost",8080)
puts "Server listen on localhost:8080"

# A function that send an html page or a 404 error
def sendHTMLPage(file_name,socket)
    begin
        # Looking for a file 
        file = File.open(file_name)
      
        # Read the content of the file and affect it to a variable
        body = file.read
        
        # Define the HTTP Header
        header = "HTTP/1.1 200 OK\r\nContent-type : text/html\r\nContent-length : #{body.length.to_s}\r\n\r\n"
        
        # Structuring the HTTP Response
        message = header+body
        
        # Send the Message response to the client
        socket.puts message
    rescue 
        # If an error occur
        # Send a 404 Error
        body = "Error 404 - Unknow ressource"
        header = "HTTP/1.1 404 Not Found\r\nContent-type : text/html\r\nContent-length : #{body.length.to_s}\r\n\r\n"
        
        # Send response to the client
        socket.puts header+body
    end
    
end


loop do
    # Start a thread for the new client request , that is not mandatory
    Thread.start(server.accept) do |socket|
        # Get the filename from the route
        route = socket.gets.split(" ")[1]

        # Send home page or an other one
        if route == "/"
            sendHTMLPage("index.html",socket)
            puts "Access to #{route}"
        else
            sendHTMLPage(route[1..-1],socket)
            puts "Access to #{route}"
        end

        # In case nothing have been putsto the client
        # puts an empty string
        socket.puts ""

        #Close the connection
        socket.close
    end
end