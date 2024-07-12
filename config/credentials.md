for information on how to use credentials in rails, use following command:

```rails credentials:help```

use following to edit credentials file:

```EDITOR="code --wait" bin/rails credentials:edit```

the `master.key` file is used to decrypt the credentials file. It should be kept secret and not checked into source control, and should be shared securely with collaborators.

```
