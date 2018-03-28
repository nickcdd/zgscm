package com.cqzg168.scm.admin.view;

import com.cqzg168.scm.domain.Orders;
import com.cqzg168.scm.domain.OrdersGoods;
import com.cqzg168.scm.domain.WithdrawApplyVO;
import com.cqzg168.scm.utils.DateUtil;
import com.cqzg168.scm.utils.Utils;
import org.apache.poi.hssf.usermodel.HSSFDataFormat;
import org.apache.poi.ss.usermodel.*;
import org.springframework.web.servlet.view.document.AbstractXlsxView;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.net.URLEncoder;
import java.util.Date;
import java.util.List;
import java.util.Map;

/**
 * Created by Administrator on 2017/7/14 0014.
 */
public class HXHKPickingGoodsExcelView extends AbstractXlsxView {
    private final static String[] HEADERS = new String[]{"货主编码", "单据类型", "客户订单号", "承运商", "收货人名称", "收货人联系方式", "省份", "城市", "区", "地址", "货品代码", "货品名称", "货品状态", "包装单位", "期待包装数量", "备注", "是否有货（1代表缺货，不填代表有货）"};

    @Override
    protected void buildExcelDocument(Map<String, Object> model, Workbook workbook, HttpServletRequest request, HttpServletResponse response) throws Exception {
        List<Orders> ordersList = (List<Orders>) model.get("ordersList");

        Sheet sheet = workbook.createSheet("待拣货列表");

        Row header = sheet.createRow(0);
        for (int i = 0; i < HEADERS.length; i++) {
            header.createCell(i).setCellValue(HEADERS[i]);
        }
        int i = 1;
        for (Orders orders : ordersList) {
            for (OrdersGoods ordersGoods : orders.getOrdersGoodsList()) {
                CellStyle style = workbook.createCellStyle();
                DataFormat format = workbook.createDataFormat();
                style.setDataFormat(format.getFormat("@"));
                int j = 0;
                Row row = sheet.createRow(i);
                //货主编码
                row.createCell(j++).setCellValue("");
                //单据类型
                row.createCell(j++).setCellValue("销售发货单");
                //客户订单号
//                row.createCell(j++).setCellValue(orders.getSid().toString());
                Cell cellDdbh = row.createCell(j++);
                cellDdbh.setCellStyle(style);
                cellDdbh.setCellValue(orders.getSid().toString());
                //承运商
                row.createCell(j++).setCellValue("");
                //收货人名称
                if (!Utils.isEmpty(orders.getShopKeeper().getRealName())) {
                    row.createCell(j++).setCellValue(orders.getShopKeeper().getRealName());
                } else {
                    row.createCell(j++).setCellValue(orders.getShopKeeper().getCname());
                }
                //收货人联系方式
                row.createCell(j++).setCellValue(orders.getShopKeeper().getTelephone());
                //省份
                row.createCell(j++).setCellValue(orders.getProvince());
                //城市
                row.createCell(j++).setCellValue(orders.getCity());
                //区
                row.createCell(j++).setCellValue(orders.getArea());
                //地址
                row.createCell(j++).setCellValue(orders.getAddress());
                //商品代码
//                row.createCell(j++).setCellValue(ordersGoods.getGoodsSpecification().getGoodsBm());
                Cell cellSpdm = row.createCell(j++);
                cellSpdm.setCellStyle(style);
                cellSpdm.setCellValue(ordersGoods.getGoodsSpecification().getGoodsBm());
//                row.createCell(j++).setCellValue(ordersGoods.getGoodsSpecification().getBarcode());
                //货品名称
                row.createCell(j++).setCellValue(ordersGoods.getGoodsCname());
                //货品状态
                row.createCell(j++).setCellValue("合格");
                //包装单位
                row.createCell(j++).setCellValue(ordersGoods.getGoodsSpecification().getCname().substring(ordersGoods.getGoodsSpecification().getCname().length() - 1, ordersGoods.getGoodsSpecification().getCname().length()));
                //期待包装数量
                row.createCell(j++).setCellValue(ordersGoods.getGoodsSpecification().getSaleCount() * ordersGoods.getGoodsCount());
                //备注
                row.createCell(j++).setCellValue("");
                //是否有货
                Cell cellHave = row.createCell(j++);
                cellHave.setCellStyle(style);
                cellHave.setCellValue("");
//                row.createCell(j++).setCellValue(DateUtil.dateToString(ordersGoods.getCreateTime(), "yyyy-MM-dd HH:mm:ss"));
                i++;
            }
        }
        try {

            String fileNmae = URLEncoder.encode("待拣货列表.xlsx", "UTF-8");
            response.setHeader("Content-Disposition", "attachment; filename=" + fileNmae);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
