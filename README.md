# CSC10003-OOP-Waste-management-and-separation-system

## MongoDB configuration

Both `src/main.cpp` and the quickstart sample expect the connection string in the `MONGODB_URI`
environment variable. This lets you point the application at a local MongoDB instance or a hosted
deployment (for example MongoDB Atlas) without touching the source code.

```
export MONGODB_URI="mongodb+srv://<user>:<password>@<cluster-url>/?retryWrites=true&w=majority"
```

Atlas and other managed deployments require TLS. If your system CA bundle does not include the CA
that signed your cluster’s certificate, pass the PEM file via `MONGODB_TLS_CA_FILE`:

```
export MONGODB_TLS_CA_FILE=/path/to/ca-bundle.pem
```

You can also toggle less secure options if you are working inside a lab environment that uses
self-signed certificates:

```
export MONGODB_TLS_ALLOW_INVALID_CERTIFICATES=1
export MONGODB_TLS_ALLOW_INVALID_HOSTNAMES=1
```

These toggles should be avoided in production, but they are useful when you only have untrusted
certificates and are otherwise blocked by `TLS handshake failed` errors, such as the one shown in
`app.out`.
