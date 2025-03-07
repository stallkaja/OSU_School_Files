#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <unistd.h>
#include <arpa/inet.h>

#define PORT 8888
#define BUFFER_SIZE 1024

void safe_function(char *buffer){
    char name[64];
    int num = 42;
    
    // Prevent buffer overflow using strncpy
    strncpy(name, buffer, sizeof(name) - 1);
    name[sizeof(name) - 1] = '\0';  // Ensure null termination
    
    printf("Hello %s%d\n", name, num);
}

int main()
{
    int server_fd, client_fd;
    struct sockaddr_in server_addr, client_addr;
    socklen_t client_len;
    char buffer[BUFFER_SIZE];
    int bytes_read;

    server_fd = socket(AF_INET, SOCK_STREAM, 0);
    if (server_fd == -1)
    {
        perror("socket");
        exit(1);
    }

    memset(&server_addr, 0, sizeof(server_addr));
    server_addr.sin_family = AF_INET;
    server_addr.sin_port = htons(PORT);
    server_addr.sin_addr.s_addr = INADDR_ANY;
    if (bind(server_fd, (struct sockaddr *)&server_addr, sizeof(server_addr)) == -1)
    {
        perror("bind");
        exit(1);
    }

    if (listen(server_fd, 5) == -1)
    {
        perror("listen");
        exit(1);
    }

    printf("Server listening on port %d\n", PORT);

    while (1)
    {
        client_len = sizeof(client_addr);
        client_fd = accept(server_fd, (struct sockaddr *)&client_addr, &client_len);
        if (client_fd == -1)
        {
            perror("accept");
            exit(1);
        }

        printf("Client connected from %s:%d\n", inet_ntoa(client_addr.sin_addr), ntohs(client_addr.sin_port));

        bytes_read = read(client_fd, buffer, BUFFER_SIZE - 1);
        if (bytes_read == -1)
        {
            perror("read");
            exit(1);
        }

        buffer[bytes_read] = '\0'; // Null terminate input
        write(client_fd, buffer, bytes_read);

        close(client_fd);
        
        safe_function(buffer);
    }

    close(server_fd);
    return 0;
}
