@page {
            @top-center {
            content: element(header);
            }
            @bottom-left{
            content: element(footer);
            }
            }
            div.header {
            padding: 10px;
            position: running(header);
            }
            div.footer {
            display: block;
            padding: 5px;
            position: running(footer);
            }
            div.title{
            color:#42517c;
            font-family: sans-serif;
            font-size:20px;
            font-style: normal;
            }
            div.subtitle{
            background:#ededed;
            color:#42517c;
            font-family:sans-serif;
            font-size=15px;
            }
            .pagenumber:before {
            content: counter(page);
            }
            .pagecount:before {
            content: counter(pages);
            }
            table {
            border-collapse: collapse;
            width: 100%;
            }

            th, td {
            padding: 8px;
            text-align: left;
            border-bottom: 1px solid #ddd;
            width: 50%;
            }
            tr:nth-child(even) {background-color: #f2f2f2;}
            table.classTableBack{
            border-bottom: 1px solid #ddd;
            width:100%;
            alignment:rigth;

            }
            th.cb{
            padding: 8px;
            border-bottom: 1px solid #ddd;
            background-color:#004481;
            color:#ffffff;
            alignment:center;
            }
            td.cd{
            padding: 8px;
            border-bottom: 1px solid #ddd;
            background-color:#ffffff;
            alignment:center;
            }@page {
            @top-center {
            content: element(header);
            }
            @bottom-left{
            content: element(footer);
            }
            }
            div{
            font-family: sans-serif;
             }
            div.header {
            padding: 10px;
            position: running(header);
            }
            div.footer {
            display: block;
            padding: 5px;
            position: running(footer);
            }
            div.title{
            color:#42517c;
            font-family: sans-serif;
            font-size:30px;
            font-style: normal;
            }
            div.subtitle{
            color:#42517c;
            font-family:sans-serif;
            font-size:20px;
            }
            .pagenumber:before {
            content: counter(page);
            }
            .pagecount:before {
            content: counter(pages);
            }
            table {
            border-collapse: collapse;
            font-family:sans-serif;
            width: 100%;
            }

            th, td {
            padding: 8px;
            text-align: left;
            border-bottom: 1px solid #ddd;
            width: 50%;
            }
            tr:nth-child(even) {background-color: #f2f2f2;}

            table.classTableBack{
            border-bottom: 1px solid #ddd;
            width:100%;
            alignment:rigth;

            }
            th.cb{
            padding: 8px;
            border-bottom: 1px solid #ddd;
            background-color:#004481;
            color:#ffffff;
            alignment:center;
            }
            td.cd{
            padding: 8px;
            border-bottom: 1px solid #ddd;
            background-color:#ffffff;
            alignment:center;
            }
