#c/cpp
https://zh-google-styleguide.readthedocs.io/en/latest/google-cpp-styleguide/contents/

#golang
https://google.github.io/styleguide/go/best-practices.html
https://go.dev/doc/effective_go
https://go.dev/blog/godoc

#python
https://docs.python-guide.org/

#bash
https://github.com/progrium/bashstyle

#git
commit的最佳实践
https://gist.github.com/luismts/495d982e8c5b1a0ced4a57cf3d93cf60
1 经常commit，经常push
   这样子能够保证所有东西都能够得到备份。因为后续可以通过git rebase来调整commit log
   所以不用担心开发过程中commit log不干净的问题

2 在feature分支上进行合并，而不要在发布分支上直接合并
   不论是使用merge, 或者rebase, 都应该在feature分支上合并测试完，
   再提交发布分支，由发布分支做fast forward合并.
   这是因为发布分支随时会有bug fix发布需求。在发布分支上做merge会block住整个流程
3 使用git rebase改写commit log
   在编辑开发的过程中，花费太多实践思考commit log怎么写是得不偿失的
   很多时候，没有测试通过的代码，也有提交的必要性，这样子就可以灵活地进行回滚
   关键是当feature对其他开发者可见时，需要对commit log进行调整，花费时间描述commit
   的内容。这些内容就像代码注释一样，对于可维护性有巨大的帮助
   commit的标准，可以参考commit的最佳实践。
   这里也衍生出来再git中做开发，应该尽量多地使用分支，从而可以方便地进行commit log的调整


#helm
https://helm.sh/docs/chart_best_practices/

#docker
https://docs.docker.com/develop/develop-images/dockerfile_best-practices/

#ansible
https://docs.ansible.com/ansible/2.8/user_guide/playbooks_best_practices.html
