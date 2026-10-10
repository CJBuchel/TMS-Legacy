# Users and passwords

Accounts are managed on the **Users** page, in the side menu. Only an admin can open it.

## The accounts you start with

A new server has one account you can log in with.

| Username | Password | Role |
| --- | --- | --- |
| `admin` | `admin` | Admin |

Change the admin password in **Setup** before doing anything else.

There is also a built-in `public` account with no password. It is what a device uses before anyone logs in, and it can only see the public screens. You do not log in to it.

## Default users

**Add default users** creates one shared account for each common role. Each account's password is the same as its username.

| Username | Password | Role |
| --- | --- | --- |
| `head_referee` | `head_referee` | Head referee |
| `referee` | `referee` | Referee |
| `judge_advisor` | `judge_advisor` | Judge advisor |
| `judge` | `judge` | Judge |

This is the quickest way to get an event running: every referee tablet logs in as `referee`. Change the passwords if the network is not private.

## Adding a user

1. Select **Add User**.
2. Enter a **username** and **password**.
3. Tick the roles the account should have.
4. Confirm.

The roles you can give are **Admin**, **Queuer**, **Head Referee**, **Referee**, **Judge Advisor**, **Judge** and **Emcee**. What each one can do is listed in [Roles at a glance](../roles/index.md).

An account can have several roles. Remember that some roles include others: a head referee can already do everything a referee and queuer can, and a judge advisor everything a judge can.

## Editing and removing users

- The pencil on a row opens **Edit User**, where you can change the password and roles.
- The bin on a row deletes the account, after a confirmation.

Changes apply the next time that account logs in. A device that is already logged in keeps working until it logs out or reconnects.

## Shared or personal accounts?

Shared accounts
:   One account per role, for example every referee uses `referee`. Simple, quick, and enough for most events. The referee's name is still recorded on each scoresheet, because referees type it into the scoring screen.

Personal accounts
:   One account per person. Useful when you want to know which account corrected a scoresheet, or want to be able to remove one person's access.

A common middle ground is shared accounts for referees and queuers, and personal accounts for the head referee, judge advisor and admins.

## Password advice

!!! warning "Use event-only passwords"
    TMS is designed for a local event network, not as a secure identity system. Passwords are stored by the server as entered and are not protected against someone with access to the server computer. Never use a password here that anyone uses anywhere else.

- Change the `admin` password.
- If the network is shared with the public, change the default account passwords too and run the server with [`--tls`](server-options.md#encryption-tls).
- After the event, there is nothing to clean up: accounts live in that event's database.
