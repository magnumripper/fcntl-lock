# fcntl-lock(1)
An exact clone of (a slightly dated version of) H. Peter Anvin's flock(1) utility, but using fcntl() locks. Also includes a simple shell script that tests basic functionality.

I wrote this because I found out that when using flock() on Linux w/ NFS (recent versions, NFS4) clients would see each other's locks, but the server would not know about client locks and vice versa. Using fcntl() instead, this problem is gone - clients and the server all share the one same view.
