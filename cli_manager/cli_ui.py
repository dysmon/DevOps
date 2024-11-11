import curses
import subprocess
import math
import commands as cli_commands
from curses import wrapper


def get_users():
    return subprocess.run(cli_commands.GET_USER_LIST, capture_output=True, text=True, shell=True).stdout.split("\n")[1:-1]


def show_users(users_window, users, current_page, amount_page, choosed_user):
    users_window.clear()
    try: 
        users_window.addstr(0, 2, f"Page {current_page} of {amount_page} | choosed {choosed_user} user")
    except curses.error:
        pass

    for index, user in enumerate(users[4 * (current_page - 1) : 4 * (current_page - 1) + 4]):
        status = "lock"
        if subprocess.run(cli_commands.CHECK_TO_LOCK.format(user), capture_output=True, text=True, shell=True,).stdout[0] in ("*", "!"):
            status = "lock    "
        else:
            status = "unlock  "

        try: 
            if choosed_user == index + 1:
                users_window.addstr(2 + index, 2, f'{status}  > {user}', curses.A_BOLD)
            else:
                users_window.addstr(2 + index, 2, f'{status} {abs(index - choosed_user + 1)}. {user}')
        except curses.error:
            pass
    users_window.refresh()


def show_header(header_window):
    header_window.clear()
    num_rows, num_cols = header_window.getmaxyx()
    try:
        header_window.addstr(0, 0, "-" * num_cols)
        header_window.addstr(2, int((num_cols - 15) / 2), "USER MANAGEMENT", curses.color_pair(1) | curses.A_UNDERLINE | curses.A_BOLD)
        header_window.addstr(4, 0, "-" * num_cols)
    except curses.error:
        pass
    header_window.refresh()


def show_hints(hints_window):
    hints_window.clear()
    num_rows, num_cols = hints_window.getmaxyx()

    try:
        hints_window.addstr(0, 0, "-" * num_cols)
        hints_window.addnstr(1, 2, "Navigation", num_cols - 3, curses.A_BOLD)
        hints_window.addnstr(2, 2, "Left and Right Arrow navigate by page", num_cols - 3)
        hints_window.addnstr(3, 2, "Up and Down move to select user", num_cols - 3)
        hints_window.addnstr(1, 43, "Actions", num_cols - 44, curses.A_BOLD)
        hints_window.addnstr(2, 43, "N create new user", num_cols - 44)
        hints_window.addnstr(3, 43, "BackSpace delete the selected user", num_cols - 44)
        hints_window.addnstr(4, 43, "Q quit the application or back", num_cols - 44)
        hints_window.addnstr(5, 43, "L/U lock and unlock selected user", num_cols - 44)
    except curses.error:
        pass

    hints_window.refresh()


def take_input(users_window, prompt="Enter your password: ", password=True, *args):
    curses.echo(False)

    header_window = args[0]
    if len(args) > 1:
        hints_window = args[1]
    
    users_window.clear()
    users_window.addstr(0, 2, prompt)
    users_window.refresh()

    text = []
    while True:
        show_header(header_window)
        if len(args) > 1:
            show_hints(hints_window)
        try:
            key = users_window.getch()
        except KeyboardInterrupt:
            return good_bye(users_window)
        users_window.clear()
        try: 
            users_window.addstr(0, 2, prompt)
        except curses.error:
           pass 
        users_window.refresh()
        if key == curses.KEY_ENTER or key in (10, 13):
            break
        elif key == 0:
            return None
        elif key in (curses.KEY_BACKSPACE, 127):
            if len(text) > 0:
                text.pop()
        elif key in range(32, 127):
            text.append(chr(key))

        if not password:
            users_window.addstr("".join(text))

    return "".join(text)

def good_bye(users_window):
        users_window.clear()
        users_window.addstr(0, 2, "In case I don't see you, good afternoon, good evening, and goodnight!")
        users_window.refresh()
        try:
            users_window.getch()
        except KeyboardInterrupt:
            pass
        return 1


def cancel(users_window):
    users_window.clear()
    users_window.addstr(0, 2, "Canceled.", curses.color_pair(1))
    users_window.refresh()
    try:
        users_window.getch()
    except KeyboardInterrupt:
        return good_bye(users_window) 


def main(stdscr):
    curses.init_pair(1, curses.COLOR_RED, curses.COLOR_BLACK)
    curses.init_pair(2, curses.COLOR_GREEN, curses.COLOR_BLACK)
    auth_state, app_state = True, True
    users = get_users()
    num_rows, num_cols = stdscr.getmaxyx()
    current_page = 1
    amount_page = math.ceil(len(users) / 4)
    choosed_user = 1
            
    header_window = curses.newwin(5, num_cols + 1, 0, 0)
    users_window = curses.newwin(max(6, int((256 + num_cols - 1) / num_cols)), num_cols, 6, 0)
    hints_window = curses.newwin(6, num_cols, 14, 0)
    while auth_state:
        sudo_password = take_input(users_window, "(Enter your sudo password (or press 'ctrl + shift + 2' to quit): ", True, header_window)
        users_window.addstr(2, 2, "Please wait a second...")
        users_window.refresh()

        if sudo_password == 1:
            return good_bye(users_window)

        result = subprocess.run(cli_commands.SUDO_MODE_ON.format(sudo_password), stderr=subprocess.PIPE, shell=True).returncode
        users_window.clear()
        if result == 0:
            users_window.addstr(0, 2, "Password coreect. Access granted!", curses.color_pair(2))
            auth_state = False
        else:
            users_window.addstr(0, 2, "Incorrect password. Please try again.", curses.color_pair(1))

        users_window.refresh()

        try:
            users_window.getch()
        except KeyboardInterrupt:
            return good_bye(users_window)
    users_window.keypad(True)
    while app_state:
        show_users(users_window, users, current_page, amount_page, choosed_user)
        show_hints(hints_window)
        show_header(header_window)

        try:
            key = users_window.getch()
        except KeyboardInterrupt:
            return good_bye(users_window)

        user = users[(current_page - 1) * 4 + choosed_user - 1]
        if key == curses.KEY_LEFT and current_page > 1:
            current_page -= 1
            choosed_user = 1
        elif key == curses.KEY_RIGHT and current_page < amount_page:
            current_page += 1
            choosed_user = 1
        elif key == curses.KEY_UP:
            if choosed_user == 1 and current_page != 1:
                current_page -= 1
                choosed_user = 4
            elif choosed_user != 1:
                choosed_user -= 1
        elif key == curses.KEY_DOWN:
            if current_page != amount_page and choosed_user % 4 == 0:
                current_page += 1
                choosed_user = 1
            elif choosed_user + ((current_page - 1) * 4) != len(users):
                choosed_user += 1
        elif key == 78:
            user_name = take_input(users_window, "Enter new user's name(or press 'ctrl + shift + 2' to back menu): ", False, header_window, hints_window)
            if user_name == 1:
                return 0
            elif user_name is None:
                cancel(users_window)                 
                continue
            password = take_input(users_window, "Enter new user's password(or press 'ctrl + shift + 2' to back menu): ", True, header_window, hints_window)
            if password is None:
                cancel(users_window)                 
                continue
            elif password == 1:
                return 0
            password2 = take_input(users_window, "Confirm new user's password(or press 'ctrl + shift + 2' to back menu): ", True, header_window, hints_window)
            if password2 is None:
                cancel(users_window)                  
                continue
            elif password == 1:
                return 0
            users_window.clear()
            if password != password2:
                users_window.addstr(0, 2, "Passwords are not match!", curses.color_pair(1))
            else:
                successful = int(subprocess.call(cli_commands.ADD_USER.format(password, user_name), shell=True))
                if successful == 0:
                    users_window.addstr(0, 2, "Successful created!", curses.color_pair(2))
                elif successful == 9:
                    users_window.addstr(0, 2, "Username already in use", curses.color_pair(1))
            users_window.refresh()
            try:
                users_window.getch()
            except KeyboardInterrupt:
                return good_bye(users_window)
            users = get_users()
            amount_page = math.ceil(len(users) / 4)
        elif key == 81:
            return good_bye(users_window)
        elif key == 76:
            subprocess.call(cli_commands.LOCK_USER.format(user), shell=True)
        elif key == 85:
            subprocess.call(cli_commands.UNLOCK_USER.format(user), shell=True)
        elif key == curses.KEY_BACKSPACE:
            approve = take_input(users_window, "Do you wanna really delete this user? YES/NO: ", False, header_window, hints_window)
            users_window.clear()
            if approve == "YES":
                subprocess.run(cli_commands.DEL_USER.format(user), capture_output=True, text=True, shell=True)
                users_window.addstr(0, 2, "Successful delete", curses.color_pair(2))
                users = get_users()
                amount_page = math.ceil(len(users) / 4)
                if choosed_user == 1 and current_page != 1:
                    current_page -= 1
                    choosed_user = 4
                elif choosed_user != 1:
                    choosed_user -= 1
            else:
                cancel(users_window)
            users_window.refresh()
            try:
                users_window.getch()
            except KeyboardInterrupt:
                return good_bye(users_window)



wrapper(main)
subprocess.run(cli_commands.SUDO_MODE_OFF, shell=True)
