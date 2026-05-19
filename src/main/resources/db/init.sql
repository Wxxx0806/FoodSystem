create table dish
(
    id          bigint auto_increment comment '主键'
        primary key,
    name        varchar(32)    not null comment '菜品名称',
    category_id bigint         not null comment '菜品分类id',
    price       decimal(10, 2) null comment '菜品价格',
    image       varchar(255)   null comment '图片',
    description varchar(255)   null comment '描述信息',
    status      int default 1  null comment '0 停售 1 起售',
    create_time datetime       null comment '创建时间',
    update_time datetime       null comment '更新时间',
    constraint idx_dish_name
        unique (name)
)
    comment '菜品' collate = utf8mb3_bin;

create table employee
(
    id          bigint auto_increment comment '主键'
        primary key,
    name        varchar(32)   not null comment '姓名',
    username    varchar(32)   not null comment '用户名',
    password    varchar(64)   not null comment '密码',
    phone       varchar(11)   not null comment '手机号',
    sex         varchar(2)    not null comment '性别',
    id_number   varchar(18)   not null comment '身份证号',
    status      int default 1 not null comment '状态 0:禁用，1:启用',
    create_time datetime      null comment '创建时间',
    update_time datetime      null comment '更新时间',
    create_user bigint        null comment '创建人',
    update_user bigint        null comment '修改人',
    constraint idx_username
        unique (username)
)
    comment '员工信息' collate = utf8mb3_bin;

create table order_detail
(
    id       bigint auto_increment comment '主键'
        primary key,
    name     varchar(32)    null comment '名字',
    image    varchar(255)   null comment '图片',
    order_id bigint         not null comment '订单id',
    dish_id  bigint         null comment '菜品id',
    number   int default 1  not null comment '数量',
    amount   decimal(10, 2) not null comment '金额'
)
    comment '订单明细表' collate = utf8mb3_bin;

create table orders
(
    id               bigint auto_increment comment '主键'
        primary key,
    number           varchar(50)          null comment '订单号',
    status           int        default 1 not null comment '订单状态 1待付款  2已完成 3已取消 4退款',
    user_id          bigint               not null comment '下单用户',
    order_time       datetime             not null comment '下单时间',
    checkout_time    datetime             null comment '结账时间',
    pay_method       int        default 1 not null comment '支付方式 1微信,2支付宝',
    pay_status       tinyint    default 0 not null comment '支付状态 0未支付 1已支付 2退款',
    amount           decimal(10, 2)       not null comment '实收金额',
    remark           varchar(100)         null comment '备注',
    phone            varchar(11)          null comment '手机号',
    user_name        varchar(32)          null comment '用户名称',
    cancel_reason    varchar(255)         null comment '订单取消原因',
    rejection_reason varchar(255)         null comment '订单拒绝原因',
    cancel_time      datetime             null comment '订单取消时间',
    tableware_number int                  null comment '餐具数量',
    tableware_status tinyint(1) default 1 not null comment '餐具数量状态  1按餐量提供  0选择具体数量'
)
    comment '订单表' collate = utf8mb3_bin;

create table user
(
    id          bigint auto_increment comment '主键ID'
        primary key,
    openid      varchar(45)                        null comment '微信 OpenID',
    name        varchar(32)                        null comment '姓名',
    phone       varchar(11)                        null comment '手机号',
    sex         varchar(2)                         null comment '性别',
    id_number   varchar(18)                        null comment '身份证号',
    avatar      varchar(500)                       null comment '头像地址',
    create_time datetime default CURRENT_TIMESTAMP null comment '创建时间'
)
    comment '用户表';

