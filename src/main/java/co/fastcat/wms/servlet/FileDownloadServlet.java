package co.fastcat.wms.servlet;

import java.io.FileInputStream;
import java.io.IOException;
import java.io.OutputStream;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import co.fastcat.wms.bean.FileInfo;
import co.fastcat.wms.dao.FileInfoDAO;

/**
 * Servlet implementation class FileUploadServlet
 */
@WebServlet("/FileDownloadServlet")
public class FileDownloadServlet extends HttpServlet {

	protected static Logger logger = LoggerFactory.getLogger(FileDownloadServlet.class);
	private static final long serialVersionUID = 1L;

	/**
	 * @see HttpServlet#HttpServlet()
	 */
	public FileDownloadServlet() {
		super();
		// TODO Auto-generated constructor stub
	}

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse
	 *      response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		doReal(request, response);
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse
	 *      response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		doReal(request, response);
	}

	protected void doReal(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String fileId = request.getParameter("id");
		if (fileId == null || fileId.isEmpty())
			return;
		FileInfoDAO fileDAO = new FileInfoDAO();
		FileInfo fInfo = fileDAO.select(fileId);

		if (fInfo == null)
			return;

		String storeFileName = fInfo.storeName;
		String prjPath = fInfo.projectId;
		if (prjPath.equals("-1"))
			prjPath = "etc";

		String serverHome = getServletContext().getRealPath("/attachFile");
		String storeFilePath = serverHome + "/" + prjPath + "/" + storeFileName;

		byte[] buffer = new byte[1024];
		
		OutputStream os = response.getOutputStream();
		FileInputStream fis = new FileInputStream(storeFilePath);
		String outFileName = new String(fInfo.fileName.getBytes(),"ISO8859-1");
		response.setContentType("application/octet-stream");
		response.setHeader("Content-Disposition", "attachment;filename=" + outFileName + ";");
		try {
			int readLen = 0;		
			while ((readLen = fis.read(buffer)) != -1) {
				os.write(buffer, 0, readLen);
			}

		} catch (Exception e) {
			logger.error("{}",e);
		} finally {
			os.flush();
			fis.close();
			os.close();
		}

	}

}
