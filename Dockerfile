# ===========================================
# Dockerfile untuk deploy MMS ke Railway
# ===========================================
# Stage 1: Build WAR — guna image Tomcat sendiri sebagai base supaya
# servlet-api.jar, jsp-api.jar, annotations-api.jar automatik tersedia
# untuk compile (servlet/JSP project ini guna package javax.servlet, sepadan dengan Tomcat 9).
FROM tomcat:9.0-jdk17 AS build

WORKDIR /app

# Copy semua source code & resource project
COPY src ./src
COPY web ./web

# Compile semua .java dalam src/java terus menggunakan javac,
# dengan classpath: semua jar dalam web/WEB-INF/lib + servlet/jsp/annotation API dari Tomcat ($CATALINA_HOME/lib)
# Pendekatan ini sengaja skip Ant/NetBeans build system (target "dist" NetBeans memerlukan
# CopyLibs jar yang hanya wujud dalam pemasangan IDE NetBeans, tidak wujud dalam persekitaran Docker).
RUN mkdir -p /app/warstage/WEB-INF/classes \
    && CP=$(find web/WEB-INF/lib -name "*.jar" | tr '\n' ':')$(find $CATALINA_HOME/lib -name "*.jar" | tr '\n' ':') \
    && javac -d /app/warstage/WEB-INF/classes -cp "$CP" $(find src/java -name "*.java")

# Susun struktur WAR: copy semua kandungan web/ (JSP, CSS, WEB-INF/lib, web.xml) ke staging,
# classes yang telah dikompil tadi sudah berada dalam warstage/WEB-INF/classes
RUN cp -r web/* /app/warstage/ \
    && cd /app/warstage \
    && jar -cf /app/ROOT.war .

# ===========================================
# Stage 2: Run WAR menggunakan Tomcat 9 yang bersih
# ===========================================
FROM tomcat:9.0-jdk17

# Buang webapps default Tomcat (ROOT, docs, examples, manager, host-manager)
RUN rm -rf /usr/local/tomcat/webapps/*

# Copy WAR yang dah dibuild dari stage 1; namakan ROOT.war supaya akses terus di domain root Railway
COPY --from=build /app/ROOT.war /usr/local/tomcat/webapps/ROOT.war

# Railway akan inject PORT secara automatik; Tomcat default dengar di 8080
EXPOSE 8080

CMD ["catalina.sh", "run"]
