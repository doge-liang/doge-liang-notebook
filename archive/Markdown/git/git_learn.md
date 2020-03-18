#   10分钟学会git
 
##  在Windows上安装Git
+   下载https://git-for-windows.github.io ，安装
+   打开：开始菜单里找到“Git”->“Git Bash” -> 命令行窗口；或者在文件夹里右键空白处，选择“git bash here”
+   全局配置：在git命令行输入
 
        $ git config --global user.name "Your Name"
        $ git config --global user.email "email@example.com"
 
##  创建/克隆版本库
+   $ cd yourdir 选择目录，该目录里的所有文件将由git跟踪管理，可以不为空
+   $ git init 创建版本库。创建后目录下会出现.git文件夹，这个目录是Git来跟踪管理版本库的，不能手动修改这个目录里面的文件
+   
+   $ cd yourdir 选择目录，将在该目录下创建与版本库同名文件夹放置克隆下来的文件
+   $ git clone http://rui@www.lzrui.cn:3345/r/open.git 
 
##  针对某版本库的操作要先进入版本库所在目录 $ cd yourrepodir
 
##  本地保存修改
+   $ git add * 将所有修改加入暂存区
+   $ git commit -m '该次修改的说明' 将暂存区的修改永久保存到版本库
 
##  设置远程服务器的版本库地址
+   $ git remote -v 查询所有远程版本库地址
+   $ git remote add origin url 添加远程版本库，如：$ git remote add origin http://rui@www.lzrui.cn:3345/r/open.git 
+   $ git remote remove origin 删除远程版本库，如果要更改远程版本库链接，要先删除，再添加
 
##  上传本地版本至远程版本库
+   $ git push origin master 
 
##  下拉远程版本库至本地
+   $ git pull origin master
 
#   20分钟进阶：版本回滚与多人协助
 
##  查看版本
+   $ git log
+   $ git log --oneline
+   $ git log --graph --oneline --decorate
 
##  版本回滚
+   $ git reset --hard commit_id 通过git log看到的某个提交开头的字符串就是commit_id 
 
##  多人协助 分支branch
+   $ git branch 查看所有分支名
+   
+   $ git branch new-branchName 以当前版本创建新分支
+   $ git branch -d branchName 删除分支
+   
+   $ git checkout branchNmae 切换分支   
 
##  合并分支
+   $ git merge other-branch-name 将其他分支合并到当前分支  (通常是切换到master分支，再合并个人分支)
+
+   如果出现冲突需要合并冲突，处理完，再能做其他的
+   合并冲突：（git的分支指示器上带有后缀merging）   修改冲突文件并提交
    +   修改冲突文件
        +   如果两个分支的同一文件都有过修改，而且修改不相同，就会出现合并冲突，需要选择使用哪一个修改
        +   提示中的conflict文件就是有冲突的
        +   打开命令行中提示有冲突的文件，Git用<<<<<<<，=======，>>>>>>>标记出不同分支的内容，删除这些标记，把文件修改成想要保存的，保存
    +   提交修改
        +   $ git add conflictFileName 或者 $ git add *
        +   $ git commit -m '修改冲突说明'
 
##  多人开发流程：在个人分支修改代码，下班前合并提交代码，上班前更新代码
+   主分支master，也可以新建一个dev分支作为频繁修改的开发主分支，master作为稳定的版本主分支
+   每个人有一个自己的分支，开发时，切换到自己的分支，把修改提交到自己的分支
+   如果多人同一时刻汇总，后上传的人可能会因为冲突（自己合并时的主分支与现在远程主分支由于有人提交而不一致了）而上传失败，需要将主分支回滚到合并前，重新进行一次
+   如果多人开发需要修改的文件有较多交集，应当经常进行汇总，以免积累过多冲突
+   完成一个小修改后，需要汇总到主分支时
    +   提交个人修改                                   git add *
    +                                                  git commit -m 'msg'
    +   切换到主分支                                   git checkout master
    +   使用pull，把主分支更新到与远程版本库一致       git pull origin master
    +   使用merge，把个人分支合并到主分支              git merge my_branch          (如有冲突：git的分支指示器上出现后缀merging -->  修改冲突，git add *  git commit -m 'msg')
    +   使用push把主分支上传远程版本库                 git push origin master
    +   查看最新的commit_id                            git log --oneline
    +   切换到个人分支                                 git checkout my_branch
    +   将个人分支指向最新提交                         git reset --hard commit_id
 
[git教程](https://www.liaoxuefeng.com/wiki/0013739516305929606dd18361248578c67b8067c8c017b000)
[git常用命令](https://ruiaa.github.io/repository/git.html)
