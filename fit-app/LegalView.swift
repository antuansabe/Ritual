import SwiftUI
@preconcurrency import WebKit

enum LegalDoc: String {
    case privacy = "privacy-policy"
    case terms = "terms-of-service"
    
    var title: String {
        switch self {
        case .privacy: return "Política de Privacidad"
        case .terms: return "Términos de Servicio"
        }
    }
}

struct LegalView: UIViewRepresentable {
    let file: LegalDoc
    
    init(file: LegalDoc) {
        self.file = file
    }
    
    // Legacy support
    init(fileName: String) {
        switch fileName {
        case "PrivacyPolicy":
            self.file = .privacy
        case "TermsOfService":
            self.file = .terms
        default:
            self.file = .privacy
        }
    }
    
    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        
        // Try new .md files first, then legacy files as fallback
        if let markdownURL = Bundle.main.url(forResource: file.rawValue, withExtension: "md") {
            loadMarkdownFile(markdownURL, in: webView)
        } else if let legacyURL = Bundle.main.url(forResource: legacyFileName, withExtension: "html") {
            webView.loadFileURL(legacyURL, allowingReadAccessTo: legacyURL.deletingLastPathComponent())
        } else {
            loadErrorHTML(in: webView)
        }
        return webView
    }
    
    private var legacyFileName: String {
        switch file {
        case .privacy: return "PrivacyPolicy"
        case .terms: return "TermsOfService"
        }
    }
    
    func updateUIView(_ webView: WKWebView, context: Context) {
        // No need to reload on update
    }
    
    private func loadMarkdownFile(_ url: URL, in webView: WKWebView) {
        do {
            let markdownContent = try String(contentsOf: url)
            let htmlContent = convertMarkdownToHTML(markdownContent)
            webView.loadHTMLString(htmlContent, baseURL: url.deletingLastPathComponent())
        } catch {
            loadErrorHTML(in: webView)
        }
    }
    
    private func convertMarkdownToHTML(_ markdown: String) -> String {
        // Basic Markdown to HTML conversion
        var html = markdown
        
        // Headers
        html = html.replacingOccurrences(of: "# ", with: "<h1>")
        html = html.replacingOccurrences(of: "\n", with: "</h1>\n", options: [], range: html.range(of: "<h1>"))
        html = html.replacingOccurrences(of: "## ", with: "<h2>")
        html = html.replacingOccurrences(of: "\n", with: "</h2>\n")
        
        // Fix headers properly
        html = html.replacingOccurrences(of: #"<h1>([^<\n]+)"#, with: "<h1>$1</h1>", options: .regularExpression)
        html = html.replacingOccurrences(of: #"<h2>([^<\n]+)"#, with: "<h2>$1</h2>", options: .regularExpression)
        
        // Bold text
        html = html.replacingOccurrences(of: #"\*\*([^*]+)\*\*"#, with: "<strong>$1</strong>", options: .regularExpression)
        
        // Lists
        html = html.replacingOccurrences(of: #"^- (.+)$"#, with: "<li>$1</li>", options: .regularExpression)
        html = html.replacingOccurrences(of: #"(<li>.*</li>)"#, with: "<ul>$1</ul>", options: .regularExpression)
        
        // Paragraphs
        html = html.replacingOccurrences(of: "\n\n", with: "</p>\n<p>")
        html = "<p>" + html + "</p>"
        
        // Fix empty paragraphs
        html = html.replacingOccurrences(of: "<p></p>", with: "")
        html = html.replacingOccurrences(of: "<p><h", with: "<h")
        html = html.replacingOccurrences(of: "</h1></p>", with: "</h1>")
        html = html.replacingOccurrences(of: "</h2></p>", with: "</h2>")
        html = html.replacingOccurrences(of: "<p><ul>", with: "<ul>")
        html = html.replacingOccurrences(of: "</ul></p>", with: "</ul>")
        
        // Add CSS styling
        let styledHTML = """
        <!DOCTYPE html>
        <html>
        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>Documento Legal</title>
            <style>
                body {
                    font-family: -apple-system, BlinkMacSystemFont, sans-serif;
                    line-height: 1.6;
                    color: #333;
                    max-width: 800px;
                    margin: 0 auto;
                    padding: 20px;
                    background-color: #fff;
                }
                h1 {
                    color: #2c3e50;
                    border-bottom: 2px solid #3498db;
                    padding-bottom: 10px;
                    margin-top: 30px;
                }
                h2 {
                    color: #34495e;
                    margin-top: 25px;
                    margin-bottom: 15px;
                }
                p {
                    margin-bottom: 15px;
                    text-align: justify;
                }
                ul {
                    margin-bottom: 15px;
                    padding-left: 20px;
                }
                li {
                    margin-bottom: 8px;
                }
                strong {
                    color: #2c3e50;
                }
                table {
                    width: 100%;
                    border-collapse: collapse;
                    margin: 20px 0;
                }
                th, td {
                    border: 1px solid #ddd;
                    padding: 12px;
                    text-align: left;
                }
                th {
                    background-color: #f8f9fa;
                    font-weight: 600;
                }
            </style>
        </head>
        <body>
            \(html)
        </body>
        </html>
        """
        
        return styledHTML
    }
    
    private func loadErrorHTML(in webView: WKWebView) {
        let errorHTML = """
        <!DOCTYPE html>
        <html>
        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>Error</title>
            <style>
                body {
                    font-family: -apple-system, BlinkMacSystemFont, sans-serif;
                    padding: 20px;
                    text-align: center;
                    background-color: #f8f9fa;
                }
                .error-container {
                    background: white;
                    padding: 40px;
                    border-radius: 10px;
                    box-shadow: 0 2px 10px rgba(0,0,0,0.1);
                    max-width: 400px;
                    margin: 50px auto;
                }
                h1 {
                    color: #e74c3c;
                    margin-bottom: 20px;
                }
                p {
                    color: #7f8c8d;
                    line-height: 1.6;
                }
            </style>
        </head>
        <body>
            <div class="error-container">
                <h1>Archivo no encontrado</h1>
                <p>No se pudo cargar el archivo: <strong>\(file.rawValue).md</strong></p>
                <p>Por favor, contacta al soporte técnico.</p>
            </div>
        </body>
        </html>
        """
        
        webView.loadHTMLString(errorHTML, baseURL: nil)
    }
}

// Vista wrapper con navegación
struct LegalDocumentView: View {
    let fileName: String
    let title: String
    
    var body: some View {
        NavigationView {
            LegalView(fileName: fileName)
                .navigationTitle(title)
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button("Cerrar") {
                            // Se maneja automáticamente por NavigationLink
                        }
                    }
                }
        }
    }
}

#Preview {
    LegalView(fileName: "PrivacyPolicy")
}