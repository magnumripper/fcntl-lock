#!/bin/sh
#
# Test fcntl locks using fcntl-lock(1)
#
# NOTE: If you use NFS, there's more to it than running just this test script:
# An NFS mount should be tested first by running this script on the server (on
# it's real filesystem, eg. ext4) and then on a client, and lastly by locking
# a file on the server (eg. using "fcntl-lock -x .lockfile sleep 300") and while
# that lock is in place, run this script on a client in whatever mounted
# directory is pointing to the *same* "physical" directory on the server.
# Using the flock(1) version of this script, you may see that it happily claims
# it got its own lock although the server already had one. This problem was not
# seen with fcntl() (so I'm glad I did this hack).

LOCKFILE=.lockfile

if $(fcntl-lock -n -x $LOCKFILE true); then
	echo "File initially not locked."
else
	echo "File is locked already. Waiting..."
	fcntl-lock -s $LOCKFILE true
fi
echo "Locking file exclusively, using fcntl lock for 5 seconds."
fcntl-lock -x $LOCKFILE sleep 5 &
sleep 1
if $(fcntl-lock -n -x $LOCKFILE true); then
	echo "Nope, it's not locked! Locking is b0rken."
else
	echo "Confirmed, file is locked. Waiting for shared lock..."
	fcntl-lock -s $LOCKFILE echo "Got it, now releasing."
fi
