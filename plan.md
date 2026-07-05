1. **Add explanatory comments to `app/lib/ui/task_list_panel.dart`**
   - Use `replace_with_git_merge_diff` to add inline comments to `ListView.builder` in `app/lib/ui/task_list_panel.dart` explaining the performance optimization and the expected impact (e.g., lazy loading, removing animation delays).

2. **Verify code changes**
   - Run `run_in_bash_session` with `cd app && dart format lib/ui/task_list_panel.dart`.
   - Run `run_in_bash_session` with `git diff`.

3. **Complete pre-commit steps to ensure proper testing, verification, review, and reflection are done.**
   - Request another code review if necessary.

4. **Submit PR**
   - Submit the PR with the required performance format.
